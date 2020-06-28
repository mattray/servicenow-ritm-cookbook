# InSpec test for recipe servicenow-task::service-request with no request

describe json('/tmp/kitchen/nodes/no-request-centos-7.json') do
  its(%w(override servicenow)) { should eq nil }
end

describe file('/tmp/kitchen/cache/service_requests.applied') do
  it { should_not exist }
end
