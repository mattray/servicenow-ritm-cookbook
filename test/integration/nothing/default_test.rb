# InSpec test for recipe servicenow-ritm::client

describe file('/tmp/kitchen/nodes/nothing-centos-7.json') do
  its('content') { should_not match(%r"values") }
  its('content') { should_not match(%r"wernstrom") }
  its('content') { should_not match(%r"guenter") }
end
