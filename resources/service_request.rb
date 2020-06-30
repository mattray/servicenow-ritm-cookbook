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
    finish = nil
    attributes = nil
    index = -1

    # iterate over the array within the item
    item[node['fqdn']].each do |request|
      index += 1
      status = request['status']
      next if 'COMPLETED'.eql?(status)
      # find the earliest timestamp for an incomplete service request
      if request['create'] < earliest
        earliest = request['create']
        sr = request['sr']
        attributes = request['payload']
        # puts "EARLIEST: #{request['sr']}"
      else
        # puts "SKIPPED: #{request['sr']}"
      end
    end

    return if sr.nil?

    puts "ATTRIBUTES:#{attributes}"

    node.override['servicenow']['task'] = sr
    unless attributes.nil?
      ::Chef::Mixin::DeepMerge.deep_merge!(attributes, node.override_attrs)
      log "SR:#{sr} attributes merged: #{attributes}"
    end

    # update the data bag item AT END OF RUN
    # add the start, finish, and status
    # require 'pry'
    # binding.pry
    # item is the data_bag_item
    start = now
    finish = Time.now.to_s
    puts "INDEX:#{index}"
    puts "START:#{start}"
    puts "FINISH:#{finish}"

  rescue Net::HTTPClientException
    log "No '#{node['servicenow-task']['data-bag']}' data bag '#{node['fqdn']}' entry available."
  end
end
