require 'spec_helper'

describe 'test::pacemaker_property' do
  context 'when all attributes are default, on rhel 7.x' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.0', step_into: 'pacemaker_property').converge(described_recipe)
    end

    before do
      stub_command("pcs property show | egrep '^[ \t]*default-resource-stickiness: 4999$'").and_return(false)
      stub_command("pcs property show | egrep '^[ \t]*cluster-recheck-interval:'").and_return(true)
    end

    it 'converges' do
      chef_run
    end

    it 'sets pacemaker property when not set' do
      expect(chef_run).to run_execute("set pacemaker property 'default-resource-stickiness'")
        .with(command: 'pcs property set default-resource-stickiness=4999')
    end

    it 'does not set pacemaker property when set' do
      stub_command("pcs property show | egrep '^[ \t]*default-resource-stickiness: 4999$'").and_return(true)
      expect(chef_run).not_to run_execute("set pacemaker property 'default-resource-stickiness'")
    end

    it 'unsets pacemaker property when set' do
      expect(chef_run).to run_execute("unset pacemaker property 'cluster-recheck-interval'")
        .with(command: 'pcs property unset cluster-recheck-interval')
    end

    it 'does not unset already unset property' do
      stub_command("pcs property show | egrep '^[ \t]*cluster-recheck-interval:'").and_return(false)
      expect(chef_run).not_to run_execute("unset pacemaker property 'cluster-recheck-interval'")
    end
  end
end
