#!/bin/bash

#current_deployment_info=$(curl -H "Authorization: Basic YWFrYXNoc2hhcm0uYWE1QGhjbC5jb206JFNoYW5lMTIzNA==" "https://api.enterprise.apigee.com/v1/organizations/eu-west1-partner26/apis/my-apigee-pets-demo{deployment-suffix}/deployments") 

#current_deployment_info=$(curl https://api.enterprise.apigee.com/v1/organizations/eu-west1-partner26/apis/my-apigee-pets-demo$deploymentSuffix/deployments -u $apigeeUsername:$apigeePwd)
current_deployment_info=$(curl https://api.enterprise.apigee.com/v1/organizations/$org/environments/test/apis/$proxyName$deploymentSuffix/deployments -u $apigeeUsername:$apigeePwd)
echo $current_deployment_info
#rev_num=$(jq -r .environment[0].revision[0].name <<< "${current_deployment_info}" ) 
#env_name=$(jq -r .environment[0].name <<< "${current_deployment_info}" ) 
#api_name=$(jq -r .name <<< "${current_deployment_info}" ) 
#org_name=$(jq -r .organization <<< "${current_deployment_info}" )

rev_num=$(jq -r .revision[0].name <<< "${current_deployment_info}" ) 
env_name=$(jq -r .environment <<< "${current_deployment_info}" ) 
api_name=$(jq -r .name <<< "${current_deployment_info}" ) 
org_name=$(jq -r .organization <<< "${current_deployment_info}" )

declare -r hardcoding_stable_revision=9

# declare -r num1=1
# pre_rev=$(expr "$rev_num" - "$num1")
stable_revision=$(expr "$rev_num" - 1)


echo $rev_num
echo $api_name
echo $org_name
echo $env_name
# echo $pre_rev
echo $stable_revision


if [$stable_revision -eq null -o $stable_revision -eq 0]
then
	echo "WARNING: Test failed, undeploying and deleting revision $rev_num"

	#curl -X DELETE --header "Authorization: Basic YWFrYXNoc2hhcm0uYWE1QGhjbC5jb206JFNoYW5lMTIzNA==" "https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$rev_num/deployments"
	curl -X DELETE https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$rev_num/deployments -u $apigeeUsername:$apigeePwd

	#curl -X DELETE --header "Authorization: Basic YWFrYXNoc2hhcm0uYWE1QGhjbC5jb206JFNoYW5lMTIzNA==" "https://api.enterprise.apigee.com/v1/organizations/$org_name/apis/$api_name/revisions/$rev_num"
	curl -X DELETE https://api.enterprise.apigee.com/v1/organizations/$org_name/apis/$api_name/revisions/$rev_num -u $apigeeUsername:$apigeePwd
else
echo "WARNING: Test failed, reverting from $rev_num to $stable_revision --- undeploying and deleting revision $rev_num"

#curl -X DELETE --header "Authorization: Basic YWFrYXNoc2hhcm0uYWE1QGhjbC5jb206JFNoYW5lMTIzNA==" "https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$rev_num/deployments"
curl -X DELETE https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$rev_num/deployments -u $apigeeUsername:$apigeePwd

#curl -X DELETE --header "Authorization: Basic YWFrYXNoc2hhcm0uYWE1QGhjbC5jb206JFNoYW5lMTIzNA==" "https://api.enterprise.apigee.com/v1/organizations/$org_name/apis/$api_name/revisions/$rev_num"
curl -X DELETE https://api.enterprise.apigee.com/v1/organizations/$org_name/apis/$api_name/revisions/$rev_num -u $apigeeUsername:$apigeePwd

#curl -X POST --header "Content-Type: application/x-www-form-urlencoded" --header "Authorization: Basic YWFrYXNoc2hhcm0uYWE1QGhjbC5jb206JFNoYW5lMTIzNA==" "https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$stable_revision/deployments"
curl -X POST --header "Content-Type: application/x-www-form-urlencoded" https://api.enterprise.apigee.com/v1/organizations/$org_name/environments/$env_name/apis/$api_name/revisions/$stable_revision/deployments -u $apigeeUsername:$apigeePwd
fi

