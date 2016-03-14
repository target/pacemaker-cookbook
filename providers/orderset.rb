# Author:: Travis Killoren
# Cookbook Name:: pacemaker
# Resource:: orderset
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

include ::Clihelper

use_inline_resources

# This resource supports the `--whyrun` flag,
# Code that changes things is wrapped with `converge_by`
def whyrun_supported?
  true
end

action :create do
  raise "No 'set' specificed to set for pacemaker_orderset[#{new_resource.name}]" if new_resource.set.nil?

  execute "create pacemaker constraint orderset '#{new_resource.name}'" do
    new_resource.setoptions['id'] = new_resource.name
    command "pcs constraint order set #{format_array(new_resource.set)} #{format_param_hash(new_resource.options)} #{format_clause_hash('setoptions', new_resource.setoptions)}"
    not_if "pcs constraint show --full | grep '(id:#{new_resource.name})'"
  end
end

action :delete do
  execute "delete pacemaker constraint orderset '#{new_resource.name}'" do
    command "pcs constraint remove #{new_resource.name}"
    only_if "pcs constraint show --full | grep '(id:#{new_resource.name})'"
  end
end
