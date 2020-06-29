# InSpec test for recipe servicenow-task::service-request

describe json('/tmp/kitchen/nodes/completed-request-centos-7.json') do
  its(%w(override servicenow)) { should eq nil }
end
