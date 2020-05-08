# ServiceNow RITM Cookbook

Change requests originating in ServiceNow (SN) need to be traced through source control and into the Chef-managed infrastrastructure and reported back to ServiceNow upon completion. This cookbook deploys a Ruby `servicenow-ritm.rb` script that queries the Chef Automate API and returns values to ServiceNow.

## Description
  * The ServiceNow RITM number will be associated with nodes via an attribute. We will use the namespace `node['servicenow']['ritm']` to identify the current/last ticket associated with the node(s).
  * This attribute will most likely be assigned to a Chef Policyfile in conjunction with whatever configuration management changes need to be made on the node. These changes are most likely an updated cookbook version, a modification to the run list, or a modified attribute. All of these changes are tracked in the Policyfile, which is tracked in source control and released via CI/CD.
  * Once this new Policyfile has been released to the file repository, the Chef Infra Server will load it via the [managed_chef_server cookbook](https://github.com/mattray/managed_chef_server-cookbook) `policyfile_loader` recipe.
  * Nodes associated with this policyfile will apply these changes through the Chef client the next time they check in with the Chef Infra Server.
  * The Chef client output (including the newly updated `servicenow` attribute) will be reported to the Chef Infra Server which will forward this information to the Chef Automate deployment.
  * Chef Automate does not currently have the capability to process incoming reports and send notifications to another system, this cookbook will deploy an external script that runs periodically. The script will checks the Automate API for nodes with the `servicenow` attribute set and notify SN those that have been updated since the last run and whether they succeeded or failed.

## Node Attributes

You will need to add `node['servicenow']['ritm']` to the nodes you want to find from the Automate API.

## Script Attributes

The [attributes file](attributes/default.rb) documents the settings for the script.
