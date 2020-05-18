#
# Cookbook:: servicenow-task
# Recipe:: client
#

if node['servicenow-task'] && node['servicenow-task']['values']

  attributes = node['servicenow-task']['values'][node.name]

  node.rm('servicenow-task', 'values') # removes other nodes' attributes

  unless attributes.nil?
    if attributes['attributes']
      ::Chef::Mixin::DeepMerge.deep_merge!(attributes['attributes'],node.override_attrs)
      log "TASK Attributes merged: #{attributes['attributes']}"
    end
    if attributes['task']
      node.override['servicenow']['task'] = attributes['task']
      log "ServiceNow TASK: #{node['servicenow']['task']}"
    end
  end
end
