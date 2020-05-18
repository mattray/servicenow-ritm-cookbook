#
# Cookbook:: servicenow-task
#

# script install location
default['servicenow-task']['dir'] = Chef::Config[:file_cache_path]

# Automate settings
default['servicenow-task']['automate']['url'] = 'https://localhost'
default['servicenow-task']['automate']['token'] = nil

# filter out older API requests, minutes
default['servicenow-task']['automate']['window'] = 120

# ServiceNow URL, unauthenticated for now
default['servicenow-task']['servicenow']['url'] = nil
default['servicenow-task']['servicenow']['user'] = nil
default['servicenow-task']['servicenow']['password'] = nil

# schedule via cron
default['servicenow-task']['cron']['minute'] = '*/10'
default['servicenow-task']['cron']['hour'] = '*'
default['servicenow-task']['cron']['day'] = '*'
default['servicenow-task']['cron']['month'] = '*'
default['servicenow-task']['cron']['weekday'] = '*'
