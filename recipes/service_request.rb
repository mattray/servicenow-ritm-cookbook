#
# Cookbook:: servicenow-task
# Recipe:: service_request
#

service_request "Apply Service Request from '#{node['servicenow-task']['data-bag']}'." do
  data_bag node['servicenow-task']['data-bag']
  action :apply
end
