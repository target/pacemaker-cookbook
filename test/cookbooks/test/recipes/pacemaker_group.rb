pacemaker_group 'haproxy-group' do
  resources ['haproxy-vip', 'haproxy-rgw-vip']
end

pacemaker_group 'haproxy2-group' do
  action :delete
end
