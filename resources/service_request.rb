resource_name :service_request
provides :service_request

property :data_bag, String, required: true

action :apply do
  data_bag = new_resource.data_bag

  # ENSURE THIS RUNS FIRST

  # find the 'servicerequests' data bag from Chef Server
  # see if there is an item that matches the node.name
  begin
    fqdn = node['fqdn']
    item = data_bag_item(data_bag, fqdn)
    sr = nil
    now = Time.now.to_s # how about the Chef Client start?
    earliest = now
    attributes = nil
    index = nil

    # iterate over the array within the item
    item[fqdn].each_with_index do |request, i|
      status = request['status']
      next if 'Completed'.eql?(status) || 'Incomplete'.eql?(status)
      # find the earliest timestamp for an incomplete service request
      if request['create'] < earliest
        index = i
        earliest = request['create']
        sr = request['sr']
        attributes = request['payload']
      end
    end

    return if sr.nil?

    # update the data bag item while in-progress
    item[fqdn][index]['start'] = now
    item[fqdn][index]['status'] = 'InProgress'
    item.save
    Chef::Log.warn("SR:#{sr} INPROGRESS")

    node.override['servicenow']['task'] = sr
    node.override['servicenow']['payload'] = attributes
    log "SR:#{sr} attributes merged: #{attributes}"

    # handlers defined only if SRs applied
    Chef.event_handler do
      on :run_completed do
        Chef::Log.warn("SR:#{sr} COMPLETED")
        item[fqdn][index]['finish'] = Time.now.to_s
        item[fqdn][index]['status'] = 'Completed'
        item.save
      end
    end

    Chef.event_handler do
      on :run_failed do
        Chef::Log.error("SR:#{sr} INCOMPLETE")
        item[fqdn][index]['finish'] = Time.now.to_s
        item[fqdn][index]['status'] = 'Incomplete'
        item.save
      end
    end

  rescue Net::HTTPClientException => e
    if e.to_s.start_with?('403')
      log "Access to '#{node['servicenow-task']['data-bag']}' data bag '#{node['fqdn']}' item is not available, check permissions. #{e.to_s}"
    else
      log "There is no '#{node['servicenow-task']['data-bag']}' data bag '#{node['fqdn']}' item available. #{e.to_s}"
    end
  end

end
