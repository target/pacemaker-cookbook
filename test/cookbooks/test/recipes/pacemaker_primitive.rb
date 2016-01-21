pacemaker_primitive 'haproxy-vip' do
  agent 'ocf:heartbeat:IPaddr2'
  params 'ip' => '192.168.100.120', 'cidr_netmask' => '32'
  op 'monitor' => { 'interval' => '30s' }
end

pacemaker_primitive 'haproxy-del-vip' do
  action :delete
end
