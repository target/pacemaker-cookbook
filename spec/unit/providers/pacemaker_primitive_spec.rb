require 'spec_helper'

describe 'test::pacemaker_primitive' do
  context 'when all attributes are default, on rhel 7.x' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.0', step_into: 'pacemaker_primitive').converge(described_recipe)
    end

    before do
      stub_command('pcs resource show haproxy-vip').and_return(false)
      stub_command('pcs resource show haproxy-del-vip').and_return(true)
    end

    it 'converges' do
      chef_run
    end

    it 'creates pacemaker primitive when it does not exist' do
      expect(chef_run).to run_execute("create pacemaker primitive 'haproxy-vip'")
        .with(command: 'pcs resource create haproxy-vip ocf:heartbeat:IPaddr2 ip=192.168.100.120 cidr_netmask=32 op monitor interval=30s')
    end

    it 'does not create pacemaker primitive when it exists' do
      stub_command('pcs resource show haproxy-vip').and_return(true)
      expect(chef_run).not_to run_execute("create pacemaker primitive 'haproxy-vip'")
    end

    it 'deletes pacemaker primitive when it exists' do
      expect(chef_run).to run_execute("delete pacemaker primitive 'haproxy-del-vip'")
        .with(command: 'pcs resource delete haproxy-del-vip')
    end

    it 'does not delete pacemaker primitive when it does not exist' do
      stub_command('pcs resource show haproxy-del-vip').and_return(false)
      expect(chef_run).not_to run_execute("delete pacemaker primitive 'haproxy-del-vip'")
    end
  end
end
