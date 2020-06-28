# ServiceNow TASK Cookbook

Change requests originating in ServiceNow (SN) need to be traced through source control and into the Chef-managed infrastrastructure and reported back to ServiceNow upon completion. The `automate` recipe deploys a Ruby `servicenow-task.rb` script that queries the Chef Automate API and returns values to ServiceNow. The `client` recipe populates information from the `node['servicenow']['task-values']` into the node.

## Automate Recipe
  * The ServiceNow TASK number will be associated with nodes via an attribute. We will use the namespace `node['servicenow']['task']` to identify the current/last ticket associated with the node(s).
  * This attribute will most likely be assigned to a Chef Policyfile in conjunction with whatever configuration management changes need to be made on the node. These changes are most likely an updated cookbook version, a modification to the run list, or a modified attribute. All of these changes are tracked in the Policyfile, which is tracked in source control and released via CI/CD.
  * Once this new Policyfile has been released to the file repository, the Chef Infra Server will load it via the [managed_chef_server cookbook](https://github.com/mattray/managed_chef_server-cookbook) `policyfile_loader` recipe.
  * Nodes associated with this policyfile will apply these changes through the Chef client the next time they check in with the Chef Infra Server.
  * The Chef client output (including the newly updated `servicenow` attribute) will be reported to the Chef Infra Server which will forward this information to the Chef Automate deployment.
  * Chef Automate does not currently have the capability to process incoming reports and send notifications to another system, this cookbook will deploy an external script that runs periodically. The script will checks the Automate API for nodes with the `servicenow` attribute set and notify SN those that have been updated since the last run and whether they succeeded or failed.

### Script Attributes

The [attributes file](attributes/default.rb) documents the settings for the script.

## service_request Recipe

The `service_request` recipe will check for the existence of a data bag defined by `node['servicenow-task']['data_bag']` and see if there is an `id` that matches the `node['fqdn']`. If there is, the content of the data bag item will be copied to the node for the duration of this chef-client run. After the application of this service request, it will be recorded so it will not be applied on future Chef client runs.

### Data Bag configuration

The Chef Infra Server should have a data bag name that matches `node['servicenow-task']['data_bag']` (`servicerequests` is the default). The current expected schema for the items is that the id matches a node's FQDN and the service request `sr` is provided by ServiceNow:
```
{
    "id": "cubert.bottlebru.sh",
    "sr": "1234",
    "payload": {
        "value": "1"
    },
}
```

The `payload` is provided by ServiceNow, a hash of attributes to apply. Potential additional fields could be `status` and/or `timestamp`, but those are not supported yet.

## Client Recipe

You will need to add `node['servicenow']['task']` to the nodes you want to find from the Automate API. The TASK may be associated with a change on a single machine, so these will be recorded in the Policyfile associated the machine. In order to use Policyfiles for more than 1 machine, the `task` may be kept in a hash with 'node.name' keys for the associated machine (and any potential applicable attributes as necessary). This recipe will map that has into the `node['servicenow']['task']` and set any other attributes as necessary. A Policyfile with

    override['servicenow-task']['task-values']['guenter']['task'] = '12345'

will map to

    node['servicenow']['task'] = '12345'

and

    override['servicenow-task']['task-values']['guenter']['attributes']['servicenow']['source_url'] = 'https://source_url'

will map to

    node['servicenow']['source_url'] = 'https://source_url'

and so on.
