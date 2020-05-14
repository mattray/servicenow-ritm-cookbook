#
# Cookbook:: servicenow-ritm
#

# script install location
default['servicenow-ritm']['dir'] = Chef::Config[:file_cache_path]

# Automate settings
default['servicenow-ritm']['automate']['url'] = 'https://localhost'
default['servicenow-ritm']['automate']['token'] = nil

# filter out older API requests, minutes
default['servicenow-ritm']['automate']['window'] = 120

# ServiceNow URL, unauthenticated for now
default['servicenow-ritm']['servicenow']['url'] = nil
default['servicenow-ritm']['servicenow']['user'] = nil
default['servicenow-ritm']['servicenow']['password'] = nil

# schedule via cron
default['servicenow-ritm']['cron']['minute'] = '*/10'
default['servicenow-ritm']['cron']['hour'] = '*'
default['servicenow-ritm']['cron']['day'] = '*'
default['servicenow-ritm']['cron']['month'] = '*'
default['servicenow-ritm']['cron']['weekday'] = '*'
