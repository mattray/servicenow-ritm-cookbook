# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'servicenow-task'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'servicenow-task::automate'
named_run_list :client, 'servicenow-task::client'
named_run_list :service_request, 'servicenow-task::service_request'
# Specify a custom source for a single cookbook:
cookbook 'servicenow-task', path: '.'

override['servicenow-task']['values']['guenter']['task'] = '00000001'
override['servicenow-task']['values']['guenter']['attributes']['servicenow']['source_url'] = 'https://gsource_url'
override['servicenow-task']['values']['guenter']['attributes']['servicenow']['dest_url'] = 'https://gdest_url'

override['servicenow-task']['values']['wernstrom'] = {
                                                      'task': '67890',
                                                      'attributes': {
                                                                     'servicenow': {
                                                                                    'source_url': 'https://wsource_url',
                                                                                    'dest_url': 'https://dest_url',
                                                                                   },
                                                                    },
                                                     }
