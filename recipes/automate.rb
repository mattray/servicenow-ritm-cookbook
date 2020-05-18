#
# Cookbook:: servicenow-task
# Recipe:: automate
#

command = node['servicenow-task']['dir'] + '/servicenow-task.rb'

# write the script out
template command do
  source 'servicenow-task.rb.erb'
  mode '0700'
end

# add the cron job
cron 'Automate-ServiceNow TASK' do
  command command
  minute node['servicenow-task']['cron']['minute']
  hour node['servicenow-task']['cron']['hour']
  day node['servicenow-task']['cron']['day']
  month node['servicenow-task']['cron']['month']
  weekday node['servicenow-task']['cron']['weekday']
end
