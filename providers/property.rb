# Author:: Jacob McCann
# Cookbook Name:: pacemaker
# Resource:: primitive
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

use_inline_resources

# This resource supports the `--whyrun` flag,
# Code that changes things is wrapped with `converge_by`
def whyrun_supported?
  true
end

action :set do
  raise "No value specificed to set for pacemaker_property[#{new_resource.name}]" if new_resource.value.nil?

  execute "set pacemaker property '#{new_resource.name}'" do
    command "pcs property set #{new_resource.name}=#{new_resource.value}"
    not_if "pcs property show | egrep '^[ \t]*#{new_resource.name}: #{new_resource.value}$'"
  end
end

action :unset do
  execute "unset pacemaker property '#{new_resource.name}'" do
    command "pcs property unset #{new_resource.name}"
    only_if "pcs property show | egrep '^[ \t]*#{new_resource.name}:'"
  end
end
