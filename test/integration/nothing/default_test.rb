# InSpec test for recipe servicenow-task::client

describe file('/tmp/kitchen/nodes/nothing-centos-7.json') do
  its('content') { should_not match(/values/) }
  its('content') { should_not match(/wernstrom/) }
  its('content') { should_not match(/guenter/) }
end
