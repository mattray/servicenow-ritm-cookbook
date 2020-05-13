#
# Cookbook:: servicenow-ritm
# Recipe:: client
#

if node['servicenow-ritm'] && node['servicenow-ritm']['values']

  attributes = node['servicenow-ritm']['values'][node.name]

  unless attributes.nil?
    if attributes['attributes']
      node.override_attrs.merge!(attributes['attributes'])
      log "RITM Attributes merged: #{attributes['attributes']}"
    end
    if attributes['ritm']
      node.override['servicenow']['ritm'] = attributes['ritm']
      log "ServiceNow RITM: #{node['servicenow']['ritm']}"
    end
  end
end
