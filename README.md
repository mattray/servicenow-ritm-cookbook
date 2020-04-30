# ServiceNow RITM Cookbook

TODO: Enter the cookbook description here.

 Description:
Change requests originating in ServiceNow (SN) need to be traced through source control and into the Chef-managed infrastrastructure and reported back to ServiceNow upon completion.
1) The ServiceNow RITM number will be associated with nodes via an attribute. We will use the namespace node['servicenow']['ritm'] to identify the current/last ticket associated with the node(s).
2) This attribute will most likely be assigned to a Chef Policyfile in conjunction with whatever configuration management changes need to be made on the node. These changes are most likely an updated cookbook version, a modification to the run list, or a modified attribute. All of these changes are tracked in the Policyfile, which is tracked in source control and released via CI/CD.
3) Once this new Policyfile has been released to the file repository (Sonatype Nexus in our case), a wrapper GovTech recipe will download it to a local directory and the Chef Infra Server will load it via the managed_chef_server cookbook "policyfile_loader" recipe.
4) Nodes associated with this policyfile will apply these changes through the Chef client next time they check in with the Chef Infra Server.
5) The Chef client output (including the newly updated "servicenow" attribute) will be reported to the Chef Infra Server which will forward this information to the Chef Automate deployment.
6) Chef Automate does not currently have the capability to process incoming reports and send notifications to another system, we will have to make this an external script that runs periodically. The script will check the Automate API for nodes with the "servicenow" attribute set and notify SN those that have been updated since the last run and whether they succeeded or failed.
Walkthrough:
I've added the attribute
override['servicenow']['ritm'] = 'ThisIsATest'
to a policyfile in my lab that applies to 3 of 8 machines. That policy went through CI/CD, published to the Chef Server, and converged on the matching nodes. Those nodes reported to Automate.
From the Automate server I can export my API token and run the curl command
curl --insecure -s -H "api-token: $TOKEN" https://inez.bottlebru.sh/api/v0/cfgmgmt/nodes?pretty -d '{ "filters": [ { "attribute": "servicenow.ritm" } ] }'
The 3 results from this query are the nodes that have the matching "servicenow.ritm" attribute.
From there we get the attributes for each of the matches with a call like this:

 curl -s --insecure -H "api-token: $TOKEN"
https://inez.bottlebru.sh/api/v0/cfgmgmt/nodes/09700a36-a2ac-474e-b17 d-f1bb58d12054/attribute
This output will be parsed to find the value of the "servicenow.ritm" attribute, which can then be used to query and notify the ServiceNow API that this RITM has been implemented in the Chef infrastructure.
Next Steps:
1) Determine how ServiceNow will update the proper policyfile.
2) Get the API calls to make to ServiceNow to update the RITM as "implemented"
3) Provide the script to run on the Automate server, with instructions for installation. A Chef
cookbook seems like a logical delivery/scheduling mechanism.
a) Is running every 10 minutes acceptable?
b) A token will have to be provided for the Automate API as an attribute.
c) No API tokens are required for ServiceNow, API access is restricted via firewalls.
