require 'spec_helper'

describe 'test::pacemaker_orderset' do
  context 'when all attributes are default, on rhel 7.x' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.0', step_into: 'pacemaker_orderset').converge(described_recipe)
    end

    before do
      stub_command("pcs constraint show --full | grep '(id:lb_constraint)'").and_return(false)
      stub_command("pcs constraint show --full | grep '(id:bad_constraint)'").and_return(true)
    end

    it 'converges' do
      chef_run
    end

    it 'creates pacemaker orderset when it does not exist' do
      expect(chef_run).to run_execute("create pacemaker constraint orderset 'lb_constraint'")
        .with(command: 'pcs constraint order set haproxy-vip haproxy-lb-clone action=stop sequential=true setoptions kind=Optional id=lb_constraint')
    end

    it 'does not create pacemaker orderset when it exists' do
      stub_command("pcs constraint show --full | grep '(id:lb_constraint)'").and_return(true)
      expect(chef_run).not_to run_execute("create pacemaker constraint orderset 'lb_constraint'")
    end

    it 'deletes pacemaker orderset when it exists' do
      expect(chef_run).to run_execute("delete pacemaker constraint orderset 'bad_constraint'")
        .with(command: 'pcs constraint remove bad_constraint')
    end

    it 'does not delete pacemaker orderset when it does not exist' do
      stub_command("pcs constraint show --full | grep '(id:bad_constraint)'").and_return(false)
      expect(chef_run).not_to run_execute("delete pacemaker constraint orderset 'bad_constraint'")
    end
  end
end
