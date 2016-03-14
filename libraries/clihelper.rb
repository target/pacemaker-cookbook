# encoding: UTF-8

#
# Cookbook Name:: pacemaker
# library:: clihelper
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

require 'shellwords'

#
# CLI Helper methods
#
module Clihelper
  #
  # Format an array of items for the commandline. Escape special shell chars
  # and put equal sign between key and value
  #
  # @param [Array] parameters
  #   a hash of parameters
  #
  # @return [String]
  #   the formated string
  #
  def format_array(array_list)
    array_str = ''
    array_list.each do |value|
      array_str << "#{value.shellescape} "
    end
    array_str.strip
  end

  #
  # Format a hash of parameters for the commandline. Escape special shell chars
  # and put equal sign between key and value
  #
  # @param [Hash] parameters
  #   a hash of parameters
  #
  # @return [String]
  #   the formated string
  #
  def format_param_hash(param_hash)
    param_str = ''
    param_hash.each do |key, value|
      param_str << "#{key.shellescape}=#{value.shellescape} "
    end
    param_str.strip
  end

  #
  # Format a hash of ops for the commandline. Escape special shell chars
  # and put equal sign between key and value
  #
  # @param [Hash] parameters
  #   a hash of parameters
  #
  # @return [String]
  #   the formated string
  #
  def format_ops_hash(op_hash)
    ops_str = ''
    op_hash.each do |key, value|
      ops_str << "op #{key} #{format_param_hash(value)} "
    end
    ops_str.strip
  end

  #
  # Create an optional clause string for a command if the hash is not empty.
  # Escape special shell chars and put equal sign between key and value
  #
  # @param [String] clause name
  #   name of the commands optional clause
  #
  # @param [Hash] parameters
  #   a hash of parameters
  #
  # @return [String]
  #   the formated string
  #
  def format_clause_hash(clause_name, clause_hash)
    clause_str = ''
    unless clause_hash == {}
      clause_str = "#{clause_name} #{format_param_hash(clause_hash)} "
    end
    clause_str.strip
  end
end
