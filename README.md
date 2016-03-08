pacemaker Cookbook
==================
[![Build Status](https://travis-ci.org/target/pacemaker-cookbook.svg?branch=master)](https://travis-ci.org/target/pacemaker-cookbook)

Cookbook that sets up a pacemaker cluster.

Requirements
------------

#### platforms

| Platform | CLI | Resource Mgmt |  Engine  | Supported? |
|----------|-----|---------------|----------|------------|
| RHEL 7.1 | PCS | Pacemaker     | Corosync | Yes        |
| RHEL 6.5 | CRM | CMAN          | Corosync | No         |


Attributes
----------
Below is a list of attributes that you are most likely to change.
see `attributes/default.rb` for a full list of attributes.

* `['pacemaker']['corosync']['cluster_name']` (`'My_Cluster'`) - Name of the cluster
* `['pacemaker']['corosync']['nodes']` (`{}`) - List of the cluster's nodes and ip addresses
* `['pacemaker']['pcs']['vault']` (`'vault_pacemaker'`) - Vault containing item with secrets for pacemaker
* `['pacemaker']['pcs']['vault_item']` (`'secrets'`) - Vault Item containing secrets for pacemaker

Resources/Providers
===================

pacemaker_primitive
-------------------
Configure and delete primitive resource.

This resource manages pacemaker-resource primitives, supporting the following actions:
* `:create`
* `:delete`

### Examples
``` ruby
pacemaker_primitive 'drbd' do
  agent "ocf:linbit:drbd"
  params 'drbd_resource' => 'r0'
  op 'monitor' => { 'interval' => '5s', 'role' => 'Master' }
  action :create
end
```

``` ruby
pacemaker_primitive 'galera' do
  agent "ocf:heartbeat:galera"
  params 'wsrep_cluster_address' => 'node1,node2,node3'
  op 'monitor' => { 'interval' => '5s', 'role' => 'Master'
  ms true
  meta 'master_max' => '1'
  action :create
end
```

pacemaker_property
------------------
Set and unset pacemaker properties.

This resource manages pacemaker properties, supporting the following actions:
* `:set`
* `:unset`

You will want to declare this resource after having created the cluster with the `pacemaker::cluster_create` recipe.

### Examples
``` ruby
pacemaker_property 'default-resource-stickiness' do
  value 4999
end

pacemaker_property 'cluster-recheck-interval' do
  action :unset
end
```

pacemaker_stonith
-----------------
Configure and delete stonith resource.

This resource manages pacemaker-resource stonith, supporting the following actions:
* `:create`
* `:delete`

### Examples
``` ruby
pacemaker_stonith 'stonith-ucs' do
  agent  'ucs'
  params 'location' => 'b0s0'
  op     'monitor' => { 'interval' => '5s' }
  action :create
end
```

``` ruby
pacemaker_stonith 'stonith-scsi-sda' do
  agent  'fence_scsi'
  params 'devices' => '/dev/sda'
  meta   'provides' => 'unfencing'
  action :create
end
```

pacemaker_group
---------------
Configure and delete resource groups.

This resource manages pacemaker-resource group, supporting the following actions:
* `:create`
* `:delete`

### Examples
``` ruby
pacemaker_group 'mygroup' do
  resources ['lbservice', 'vip']
  meta {}
  action :create
end
```

pacemaker_orderset
------------------
This resource manages the order pacemaker-contraint using the order set syntax, supporting the following actions:
* `:create`
* `:delete`

### Examples
``` ruby
pacemaker_orderset 'start_neutron_layer3' do
  set        ['neutron-netns-clone',
              'neutron-server-clone',
              'neutron-l3-agent-clone',
              'neutron-metadata-agent-clone',
              'neutron-dhcp-agent-clone']
  options 'action' => 'start', 'sequential' => 'true'
  setoptions 'kind' => 'Mandatory'
end
```

Recipes
-------
#### pacemaker::default

Include `pacemaker::default` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[pacemaker::default]"
  ]
}
```

#### pacemaker::node_prepare

Installs required components to the node.  Does not create or manage a cluster.
This recipe assume you already in your `run_list` a cookbook/recipe to setup repos necessary for packages.
You can always choose to just include `yum::default` in your `run_list` for default public repositories.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[pacemaker::node_prepare]"
  ]
}
```

#### pacemaker::cluster_create

Creates a pacemaker cluster consisting of `node['pacemaker']['corosync']['nodes']`.

`recipe[pacemaker::node_prepare]` must have been ran on all nodes first.

This should be run only from 1 cluster node.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[pacemaker::cluster_create]"
  ]
}
```

Testing
-------
Testing utilizes ChefDK >= 0.10.0 with its native gems.

If you run into issues running tests please be sure you do not have extra gems installed in your ChefDK environment as they could cause conflicts.

To be sure you do not have any extra gems installed you can run `rm -rf ~/.chefdk/gem` to remove any extra gems.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


License and Authors
-------------------

Author:: Travis Killoren (<Travis.Killoren@Target.com>)

```text
Copyright:: 2016, Target Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
