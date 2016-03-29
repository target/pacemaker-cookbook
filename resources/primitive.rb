# Author:: Travis Killoren
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

actions :create, :delete
default_action :create

attribute :name,   kind_of: String, name_attribute: true
attribute :agent,  kind_of: String
attribute :params, kind_of: Hash,    default: {}
attribute :op,     kind_of: Hash,    default: {}
attribute :meta,   kind_of: Hash,    default: {}
attribute :ms,     kind_of: [TrueClass, FalseClass], default: false
attribute :clone,  kind_of: [TrueClass, FalseClass], default: false
attribute :disabled, kind_of: [TrueClass, FalseClass], default: false
attribute :clone_params, kind_of: Hash
attribute :master_params, kind_of: Hash
