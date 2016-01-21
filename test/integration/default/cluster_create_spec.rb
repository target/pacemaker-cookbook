describe command('pcs status') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Online: \[ mgmt1 \]/) }
  its('stdout') { should match(/mgmt1: Online/) }
end
