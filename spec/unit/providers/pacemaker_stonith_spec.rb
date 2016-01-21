require 'spec_helper'

describe 'test::pacemaker_stonith' do
  context 'when all attributes are default, on rhel 7.x' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.0', step_into: 'pacemaker_stonith').converge(described_recipe)
    end

    before do
      stub_command('pcs stonith show stonith-ucs').and_return(false)
      stub_command('pcs stonith show stonith-del').and_return(true)
    end

    it 'converges' do
      chef_run
    end

    it 'creates pacemaker stonith when it does not exist' do
      expect(chef_run).to run_execute("create pacemaker stonith 'stonith-ucs'")
        .with(command: 'pcs stonith create stonith-ucs ucs location=b0s0 op monitor interval=5s')
    end

    it 'does not create pacemaker stonith when it exists' do
      stub_command('pcs stonith show stonith-ucs').and_return(true)
      expect(chef_run).not_to run_execute("create pacemaker stonith 'stonith-ucs'")
    end

    it 'deletes pacemaker stonith when it exists' do
      expect(chef_run).to run_execute("delete pacemaker stonith 'stonith-del'")
        .with(command: 'pcs stonith delete stonith-del')
    end

    it 'does not delete pacemaker stonith when it does not exist' do
      stub_command('pcs stonith show stonith-del').and_return(false)
      expect(chef_run).not_to run_execute("delete pacemaker stonith 'stonith-del'")
    end
  end
end
