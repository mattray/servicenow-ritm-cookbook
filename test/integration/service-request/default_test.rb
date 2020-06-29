# InSpec test for recipe servicenow-task::service-request

describe json('/tmp/kitchen/nodes/service-request-centos-7.json') do
  its(%w(override servicenow task)) { should eq 'ABC123' }
  its(%w(override one)) { should eq '1' }
  its(%w(override two)) { should eq '2' }
  its(%w(override three)) { should eq '3' }
end

# describe file('/tmp/kitchen/cache/service_requests.applied') do
#   its('content') { should match(/ABC123/) }
# end
