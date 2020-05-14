# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'servicenow-ritm'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'servicenow-ritm::automate'
named_run_list :client, 'servicenow-ritm::client'

# Specify a custom source for a single cookbook:
cookbook 'servicenow-ritm', path: '.'

override['servicenow-ritm']['values']['guenter']['ritm'] = '00000001'
override['servicenow-ritm']['values']['guenter']['attributes']['servicenow']['source_url'] = 'https://gsource_url'
override['servicenow-ritm']['values']['guenter']['attributes']['servicenow']['dest_url'] = 'https://gdest_url'

override['servicenow-ritm']['values']['wernstrom'] = {
                                                      'ritm': '67890',
                                                      'attributes': {
                                                                     'servicenow': {
                                                                                    'source_url': 'https://wsource_url',
                                                                                    'dest_url': 'https://dest_url'
                                                                                   }
                                                                    }
                                                     }
