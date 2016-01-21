# Author:: Travis Killoren
# Cookbook Name:: pacemaker
# Resource:: group
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
  execute "create pacemaker resource group '#{new_resource.name}'" do
    command "pcs resource group add #{new_resource.name} #{format_array(new_resource.resources)}"
    not_if "pcs resource show #{new_resource.name}"
  end
end

action :delete do
  execute "delete pacemaker resource group '#{new_resource.name}'" do
    command "pcs resource ungroup #{new_resource.name} --wait"
    only_if "pcs resource show #{new_resource.name}"
  end
end
