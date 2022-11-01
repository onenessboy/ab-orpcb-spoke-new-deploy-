# Orpheus Cubebuilder on Synapse - engagement workspace with Terraform 

This repo for rolling out a complete [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) enterprise environment via Terraform. 

This feature includes fixes for creating tfstate files in hub subscription storage account, but not in spoke

New Fixes included:
* Tested for 8 character atlas code as client code for future deployments
* Incorrect sparkpool version got fixed with 3.1 now
* Dynamic context name according environment parameter introduced
* Storage account public access needs to be disabled. Its completed now
* Incorrect Synapse admin object id fixed now

New Fixes Done:
* Shortcode in names for location
* local tags
* storage account role assignments
* KV rbac enablement
* KV role assignment

# Metadata Config management
File structure/convention for the config files. Those are json files which would contain various properties/value needed for azure resources; customizable per environment, engagement

\config					// config for the infra environment
	base.json			//PROD - default (base) config/properties (mandatory)
	{env}.json			//Override for environment (optional)		- eg feature flag/conditional resource deployment; different skus/tests, etc
	engagement\
	client_code.json	//PROD - default for client (base) (optional)
	client_code.{env}.json  //Override for client/environment (optional)

	
Merge order of config properties
	{env}.json 						-> base.json  	=> result.json 
	engagement\client_code.json 		-> result.json 	=> result.json 
	engagement\client_code.{env}.json 	-> result.json 	=> result.json

	
Merge order of config properties
	{env}.json 						-> base.json  	=> result.json 
	engagement\client_code.json 		-> result.json 	=> result.json 
	engagement\client_code.{env}.json 	-> result.json 	=> result.json

# Help make this document better
This guide, as well as the rest of our docs, are available on GitHub. We welcome your contributions.

- *Suggest an edit to this page*  (please read the contributing guide first  //TODO - to be added).
- To report a problem in the documentation, or to submit feedback and comments, please open an issue on GitHub. Reach out to #orpcb team via slack
- ORPCB is always seeking ways to improve experience with the product. If you would like to share feedback, please be sure to reach out.