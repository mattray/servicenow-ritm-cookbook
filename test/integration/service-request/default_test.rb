# InSpec test for recipe servicenow-task::service-request

describe json('/tmp/kitchen/nodes/service-request-centos-7.json') do
  its(%w(override servicenow task)) { should eq 'ABC123' }
  its(%w(override servicenow payload one)) { should eq '1' }
  its(%w(override servicenow payload two)) { should eq '2' }
  its(%w(override servicenow payload three)) { should eq '3' }
end

describe json('/tmp/kitchen/data_bags/servicerequests/service-request-centos-7.vagrantup.com.json') do
  its(['service-request-centos-7.vagrantup.com', 0, 'sr']) { should eq 'DEF234' }
  its(['service-request-centos-7.vagrantup.com', 0, 'start']) { should eq '2020-06-29 06:28:44.349270532 +0000' }
  its(['service-request-centos-7.vagrantup.com', 0, 'finish']) { should eq '2020-06-29 06:28:47.349270532 +0000' }
  its(['service-request-centos-7.vagrantup.com', 0, 'status']) { should eq 'Completed' }
  its(['service-request-centos-7.vagrantup.com', 1, 'sr']) { should eq 'FGH456' }
  its(['service-request-centos-7.vagrantup.com', 1, 'start']) { should eq nil }
  its(['service-request-centos-7.vagrantup.com', 1, 'finish']) { should eq nil }
  its(['service-request-centos-7.vagrantup.com', 1, 'status']) { should eq nil }
  its(['service-request-centos-7.vagrantup.com', 2, 'sr']) { should eq 'RST456' }
  its(['service-request-centos-7.vagrantup.com', 2, 'start']) { should eq nil }
  its(['service-request-centos-7.vagrantup.com', 2, 'finish']) { should eq nil }
  its(['service-request-centos-7.vagrantup.com', 2, 'status']) { should eq nil }
  its(['service-request-centos-7.vagrantup.com', 3, 'sr']) { should eq 'ABC123' }
  its(['service-request-centos-7.vagrantup.com', 3, 'start']) { should match /^2020/ }
  its(['service-request-centos-7.vagrantup.com', 3, 'finish']) { should match /^2020/ }
  its(['service-request-centos-7.vagrantup.com', 3, 'status']) { should eq 'Completed' }
  its(['service-request-centos-7.vagrantup.com', 4, 'sr']) { should eq 'XYZ987' }
  its(['service-request-centos-7.vagrantup.com', 4, 'start']) { should eq nil }
  its(['service-request-centos-7.vagrantup.com', 4, 'finish']) { should eq nil }
  its(['service-request-centos-7.vagrantup.com', 4, 'status']) { should eq nil }
end
