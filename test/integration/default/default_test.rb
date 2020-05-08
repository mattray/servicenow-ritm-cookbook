# InSpec test for recipe servicenow-ritm::default


# script exists
describe file('/tmp/kitchen/cache/servicenow-ritm.rb') do
  it { should exist }
  it { should be_executable }
end

# add crontab entry for cron[knife ec backup]
describe crontab do
  its('commands') { should include '/tmp/kitchen/cache/servicenow-ritm.rb' }
end

describe crontab.commands('/tmp/kitchen/cache/servicenow-ritm.rb') do
  its('minutes') { should cmp '*/10' }
  its('hours') { should cmp '*' }
  its('day') { should cmp '*' }
  its('month') { should cmp '*' }
  its('weekday') { should cmp '*' }
end
