#
# Cookbook:: servicenow-ritm
# Recipe:: default
#

# write the script out
template node['servicenow-ritm']['dir'] + '/servicenow-ritm.rb' do
  source 'servicenow-ritm.rb.erb'
  mode '0700'
end


# # add a cron job
#   backup_dir = new_resource.directory
#   command = "#{backup_dir}/backup.sh"

#   directory backup_dir

#   # shell script for backup
#   file command do
#     mode '0700'
#     content "#/bin/sh
# cd #{backup_dir}
# PATH=$PATH:/opt/opscode/embedded/bin /opt/opscode/embedded/bin/knife ec backup --with-key-sql --with-user-sql -c /etc/opscode/pivotal.rb backup > backup.log 2>&1
# cd backup
# cp -r /etc/opscode/managed chef_managed_orgs
# tar -czf ../#{new_resource.prefix}`date +%Y%m%d%H%M`.tgz *
# cd ..
# rm -rf backup"
#   end

#   cron "knife ec backup #{backup_dir}" do
#     environment('PWD' => backup_dir)
#     command command
#     minute new_resource.minute
#     hour new_resource.hour
#     day new_resource.day
#     month new_resource.month
#     weekday new_resource.weekday
#   end
