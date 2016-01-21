require 'spec_helper'

describe 'pacemaker::node_prepare' do
  context 'when all attributes are default, on rhel 7.x' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.0') do |node, server|
        node.automatic['hostname'] = 'mgmt1'
        node.set['pacemaker']['corosync']['nodes'] = { 'mgmt1' => '192.168.100.61', 'mgmt2' => '192.168.100.62', 'mgmt3' => '192.168.100.63' }
        inject_databags(server)
      end.converge(described_recipe)
    end

    it 'converges' do
      chef_run
    end

    it 'installs pacemaker packages' do
      expect(chef_run).to install_package 'pcs'
      expect(chef_run).to install_package 'fence-agents-all'
    end

    it 'removes node name alias from localhost address' do
      expect(chef_run).to update_hostsfile_entry('127.0.0.1').with(hostname: 'localhost', aliases: ['localhost.localdomain'])
    end

    it 'sets up /etc/hosts with entries for cluster nodes' do
      expect(chef_run).to create_hostsfile_entry_if_missing('192.168.100.61').with(hostname: 'mgmt1')
      expect(chef_run).to create_hostsfile_entry_if_missing('192.168.100.62').with(hostname: 'mgmt2')
      expect(chef_run).to create_hostsfile_entry_if_missing('192.168.100.63').with(hostname: 'mgmt3')
    end

    it 'sets password for hacluster user' do
      skip 'need to add'
    end

    it 'starts pcsd' do
      expect(chef_run).to enable_service 'pcsd'
      expect(chef_run).to start_service 'pcsd'
    end
  end
end
