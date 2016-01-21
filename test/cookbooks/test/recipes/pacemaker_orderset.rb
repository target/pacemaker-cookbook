pacemaker_orderset 'lb_constraint' do
  set ['haproxy-vip', 'haproxy-lb-clone']
  options 'action' => 'stop', 'sequential' => 'true'
  setoptions 'kind' => 'Optional'
end

pacemaker_orderset 'bad_constraint' do
  action :delete
end
