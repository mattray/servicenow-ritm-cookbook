#
# Cookbook:: servicenow-ritm
# Recipe:: client
#

if node['servicenow-ritm'] && node['servicenow-ritm']['values']

  attributes = node['servicenow-ritm']['values'][node.name]

  node.rm('servicenow-ritm', 'values') # removes other nodes' attributes

  unless attributes.nil?
    if attributes['attributes']
      ::Chef::Mixin::DeepMerge.deep_merge!(attributes['attributes'],node.override_attrs)
      log "RITM Attributes merged: #{attributes['attributes']}"
    end
    if attributes['ritm']
      node.override['servicenow']['ritm'] = attributes['ritm']
      log "ServiceNow RITM: #{node['servicenow']['ritm']}"
    end
  end
end
