require 'spec_helper'

describe 'test::pacemaker_group' do
  context 'when all attributes are default, on rhel 7.x' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.0', step_into: 'pacemaker_group').converge(described_recipe)
    end

    before do
      stub_command('pcs resource show haproxy-group').and_return(false)
      stub_command('pcs resource show haproxy2-group').and_return(true)
    end

    it 'converges' do
      chef_run
    end

    it 'creates pacemaker group when it does not exist' do
      expect(chef_run).to run_execute("create pacemaker resource group 'haproxy-group'")
        .with(command: 'pcs resource group add haproxy-group haproxy-vip haproxy-rgw-vip')
    end

    it 'does not create pacemaker group when it exists' do
      stub_command('pcs resource show haproxy-group').and_return(true)
      expect(chef_run).not_to run_execute("create pacemaker resource group 'haproxy-group'")
    end

    it 'deletes pacemaker group when it exists' do
      expect(chef_run).to run_execute("delete pacemaker resource group 'haproxy2-group'")
        .with(command: 'pcs resource ungroup haproxy2-group --wait')
    end

    it 'does not delete pacemaker group when it does not exist' do
      stub_command('pcs resource show haproxy2-group').and_return(false)
      expect(chef_run).not_to run_execute("delete pacemaker resource group 'haproxy2-group'")
    end
  end
end
