require 'spec_helper'

describe 'pacemaker::cluster_create' do
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

    it 'sets up auth tokens' do
      expect(chef_run).to run_execute('Setup authentication tokens for pcs command')
        .with(command: 'pcs cluster auth -u hacluster -p ha_pass mgmt1 mgmt2 mgmt3')
    end

    it 'starts corosync' do
      expect(chef_run).to run_execute('Create and start cluster-engine (corosync)')
        .with(command: 'pcs cluster setup --start --name cluster mgmt1 mgmt2 mgmt3 && sleep 2',
              creates: '/etc/corosync/corosync.conf')
    end
  end
end
