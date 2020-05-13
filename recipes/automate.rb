#
# Cookbook:: servicenow-ritm
# Recipe:: automate
#

command = node['servicenow-ritm']['dir'] + '/servicenow-ritm.rb'

# write the script out
template command do
  source 'servicenow-ritm.rb.erb'
  mode '0700'
end

# add the cron job
cron "Automate-ServiceNow RITM" do
  command command
  minute node['servicenow-ritm']['cron']['minute']
  hour node['servicenow-ritm']['cron']['hour']
  day node['servicenow-ritm']['cron']['day']
  month node['servicenow-ritm']['cron']['month']
  weekday node['servicenow-ritm']['cron']['weekday']
end
