pacemaker_property 'default-resource-stickiness' do
  value 4999
end

pacemaker_property 'cluster-recheck-interval' do
  action :unset
end
