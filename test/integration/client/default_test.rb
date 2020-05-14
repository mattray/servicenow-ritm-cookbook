# InSpec test for recipe servicenow-ritm::client

describe json('/tmp/kitchen/nodes/client-centos-7.json') do
  its(['override','servicenow','ritm']) { should eq '12345' }
  its(['override','servicenow','source_url']) { should eq 'https://source_url' }
end

describe file('/tmp/kitchen/nodes/client-centos-7.json') do
  its('content') { should_not match(%r"wernstrom") }
  its('content') { should_not match(%r"guenter") }
end
