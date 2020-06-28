# InSpec test for recipe servicenow-task::service-request with no payload

describe json('/tmp/kitchen/nodes/no-request-payload-centos-7.json') do
  its(%w(override servicenow task)) { should eq 'CDE234' }
end

describe file('/tmp/kitchen/nodes/no-request-payload-centos-7.json') do
  its('content') { should_not match(/three/) }
end

describe file('/tmp/kitchen/cache/service_requests.applied') do
  its('content') { should match(/CDE234/) }
end
