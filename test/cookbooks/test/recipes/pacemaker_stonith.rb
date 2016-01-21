pacemaker_stonith 'stonith-ucs' do
  agent 'ucs'
  params 'location' => 'b0s0'
  op 'monitor' => { 'interval' => '5s' }
end

pacemaker_stonith 'stonith-del' do
  action :delete
end
