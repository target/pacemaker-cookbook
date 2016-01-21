#
# Cookbook Name:: pacemaker
# Recipe:: cluster_create
#
# Copyright 2016, Target Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This recipe can be run from any node in the cluster, but
# should not be run on more than one node

include_recipe 'chef-vault::default'

creds = chef_vault_item(node['pacemaker']['pcs']['vault'], node['pacemaker']['pcs']['vault_item'])

#
# Setup authorization for pcs command to funtion
#
execute 'Setup authentication tokens for pcs command' do
  command "pcs cluster auth -u hacluster -p #{creds['password']} #{node['pacemaker']['corosync']['nodes'].keys.join(' ')}"
  sensitive true
  creates '/var/lib/pcsd/pcs_user.conf'
  creates '/var/lib/pcsd/tokens'
end

#
# Setup corosync and start it
#
execute 'Create and start cluster-engine (corosync)' do
  command "pcs cluster setup --start --name #{node['pacemaker']['corosync']['cluster_name']} #{node['pacemaker']['corosync']['nodes'].keys.join(' ')} && sleep 2"
  creates '/etc/corosync/corosync.conf'
end

#
# Wait until cluster is verified to be up
#
execute 'Verify cluster-engine running' do
  command '[ $(pcs status cluster | grep -c "UNCLEAN (offline)") -eq 0 ]'
  retries 50
  retry_delay 1
end
