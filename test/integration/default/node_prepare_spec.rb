describe package('pcs') do
  it { should be_installed }
end

describe service('pcsd') do
  it { should be_enabled }
  it { should be_running }
end

describe service('pacemaker') do
  it { should be_running }
  # Uncomment after https://github.com/chef/inspec/pull/356 implemented
  # it { should_not be_enabled } # pcs disables the service
end

describe service('corosync') do
  it { should be_running }
  # Uncomment after https://github.com/chef/inspec/pull/356 implemented
  # it { should_not be_enabled } # pcs disables the service
end
