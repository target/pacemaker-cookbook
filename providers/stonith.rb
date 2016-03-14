# Author:: Travis Killoren
# Cookbook Name:: pacemaker
# Resource:: stonith
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
  raise "No agent specificed to set for pacemaker_stonith[#{new_resource.name}]" if new_resource.agent.nil?

  execute "create pacemaker stonith '#{new_resource.name}'" do
    command "pcs stonith create #{new_resource.name} #{new_resource.agent} #{format_param_hash(new_resource.params)} " \
      "#{format_ops_hash(new_resource.op)} #{format_clause_hash('meta', new_resource.meta)}".strip
    not_if "pcs stonith show #{new_resource.name}"
  end
end

action :delete do
  execute "delete pacemaker stonith '#{new_resource.name}'" do
    command "pcs stonith delete #{new_resource.name}"
    only_if "pcs stonith show #{new_resource.name}"
  end
end
