resource_name :service_request
provides :service_request

property :data_bag, String, required: true

action :apply do
  data_bag = new_resource.data_bag
  service_requests_applied = "#{Chef::Config[:file_cache_path]}/service_requests.applied"

  # find the 'servicerequests' data bag from Chef Server
  # see if there is an item that matches the node.name
  begin
    item = data_bag_item(data_bag, node['fqdn'])
    sr = item['sr']

    # Record SR
    append_if_no_line "Record SR:#{sr}" do
      path service_requests_applied
      line sr
    end

    # Skips repeated requests of same SR
    ruby_block "Apply SR:#{sr} payload" do
      block do
        node.override['servicenow']['task'] = sr
        attributes = item['payload']
        unless attributes.nil?
          ::Chef::Mixin::DeepMerge.deep_merge!(attributes, node.override_attrs)
          log "SR:#{sr} attributes merged: #{attributes}"
        end
      end
      action :nothing
      subscribes :run, "append_if_no_line[Record SR:#{sr}]", :immediately
    end

  rescue Net::HTTPClientException
    log "No '#{node['servicenow-task']['data-bag']}' data bag '#{node['fqdn']}' entry available."
  end
end
