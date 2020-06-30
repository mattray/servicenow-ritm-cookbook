# InSpec test for recipe servicenow-task::service-request

describe json('/tmp/kitchen/nodes/inprogress-request-centos-7.json') do
  its(%w(override servicenow task)) { should_not eq 'ABC123' }
  its(%w(override servicenow payload one)) { should_not eq '1' }
  its(%w(override servicenow payload two)) { should_not eq '2' }
  its(%w(override servicenow payload three)) { should_not eq '3' }
  its(%w(override servicenow task)) { should eq 'RST456' }
  its(%w(override servicenow payload one)) { should eq '4' }
  its(%w(override servicenow payload two)) { should eq '5' }
  its(%w(override servicenow payload three)) { should eq '6' }
end

describe json('/tmp/kitchen/data_bags/servicerequests/inprogress-request-centos-7.vagrantup.com.json') do
  its(['inprogress-request-centos-7.vagrantup.com', 0, 'sr']) { should eq 'DEF234' }
  its(['inprogress-request-centos-7.vagrantup.com', 0, 'start']) { should eq '2020-06-29 06:28:44.349270532 +0000' }
  its(['inprogress-request-centos-7.vagrantup.com', 0, 'finish']) { should eq '2020-06-29 06:28:47.349270532 +0000' }
  its(['inprogress-request-centos-7.vagrantup.com', 0, 'status']) { should eq 'Completed' }
  its(['inprogress-request-centos-7.vagrantup.com', 1, 'sr']) { should eq 'FGH456' }
  its(['inprogress-request-centos-7.vagrantup.com', 1, 'start']) { should eq nil }
  its(['inprogress-request-centos-7.vagrantup.com', 1, 'finish']) { should eq nil }
  its(['inprogress-request-centos-7.vagrantup.com', 1, 'status']) { should eq nil }
  its(['inprogress-request-centos-7.vagrantup.com', 2, 'sr']) { should eq 'RST456' }
  its(['inprogress-request-centos-7.vagrantup.com', 2, 'start']) { should_not eq '2020-06-29 06:28:44.349270532 +0000' }
  its(['inprogress-request-centos-7.vagrantup.com', 2, 'start']) { should match /2020/ }
  its(['inprogress-request-centos-7.vagrantup.com', 2, 'finish']) { should_not eq nil }
  its(['inprogress-request-centos-7.vagrantup.com', 2, 'finish']) { should match /2020/ }
  its(['inprogress-request-centos-7.vagrantup.com', 2, 'status']) { should eq 'Completed' }
  its(['inprogress-request-centos-7.vagrantup.com', 3, 'sr']) { should eq 'ABC123' }
  its(['inprogress-request-centos-7.vagrantup.com', 3, 'start']) { should eq nil }
  its(['inprogress-request-centos-7.vagrantup.com', 3, 'finish']) { should eq nil }
  its(['inprogress-request-centos-7.vagrantup.com', 3, 'status']) { should eq nil }
  its(['inprogress-request-centos-7.vagrantup.com', 4, 'sr']) { should eq 'XYZ987' }
  its(['inprogress-request-centos-7.vagrantup.com', 4, 'start']) { should eq '2020-06-29 06:28:44.349270532 +0000' }
  its(['inprogress-request-centos-7.vagrantup.com', 4, 'finish']) { should eq '2020-06-29 06:28:47.349270532 +0000' }
  its(['inprogress-request-centos-7.vagrantup.com', 4, 'status']) { should eq 'Incomplete' }
end
