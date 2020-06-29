resource_name :service_request
provides :service_request

property :data_bag, String, required: true

action :apply do
  data_bag = new_resource.data_bag

  # find the 'servicerequests' data bag from Chef Server
  # see if there is an item that matches the node.name
  begin
    item = data_bag_item(data_bag, node['fqdn'])
    sr = nil
    timestamp = Time.now
    attributes = nil

    # iterate over the array within the item
    item[node['fqdn']].each do |request|
      status = request['status']
      next if 'COMPLETED'.eql?(status)
      # find the earliest timestamp for an incomplete service request
      if request['timestamp'].nil? || request['timestamp'] < timestamp.to_s
        sr = request['sr']
        timestamp = request['timestamp']
        attributes = request['payload']
        # puts "EARLIEST: #{request['sr']}"
      else
        # puts "SKIPPED: #{request['sr']}"
      end
    end

    return if sr.nil?

    node.override['servicenow']['task'] = sr
    unless attributes.nil?
      ::Chef::Mixin::DeepMerge.deep_merge!(attributes, node.override_attrs)
      log "SR:#{sr} attributes merged: #{attributes}"
    end

    # update the data bag item

  rescue Net::HTTPClientException
    log "No '#{node['servicenow-task']['data-bag']}' data bag '#{node['fqdn']}' entry available."
  end
end
