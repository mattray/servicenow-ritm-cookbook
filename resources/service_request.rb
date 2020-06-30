resource_name :service_request
provides :service_request

property :data_bag, String, required: true

action :apply do
  data_bag = new_resource.data_bag

  # ENSURE THIS RUNS FIRST

  # find the 'servicerequests' data bag from Chef Server
  # see if there is an item that matches the node.name
  begin
    item = data_bag_item(data_bag, node['fqdn'])
    sr = nil
    now = Time.now.to_s # how about the Chef Client start?
    earliest = now
    attributes = nil
    index = nil

    # iterate over the array within the item
    item[node['fqdn']].each_with_index do |request, i|
      status = request['status']
      next if 'COMPLETED'.eql?(status)
      # find the earliest timestamp for an incomplete service request
      if request['create'] < earliest
        index = i
        earliest = request['create']
        sr = request['sr']
        attributes = request['payload']
      end
    end

    return if sr.nil?

    node.override['servicenow']['task'] = sr
    unless attributes.nil?
      ::Chef::Mixin::DeepMerge.deep_merge!(attributes, node.override_attrs)
      log "SR:#{sr} attributes merged: #{attributes}"
    end

    # update the data bag item AT END OF RUN
    item[node['fqdn']][index]['start'] = now
    item[node['fqdn']][index]['finish'] = Time.now.to_s # write this in a handler?
    item[node['fqdn']][index]['status'] = 'COMPLETED'
    item.save

  rescue Net::HTTPClientException
    log "No '#{node['servicenow-task']['data-bag']}' data bag '#{node['fqdn']}' entry available."
  end
end
