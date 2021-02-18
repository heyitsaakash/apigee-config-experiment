
#!/bin/bash 

#need dyamic variables 
#1. organization name
#2. username
#3. password
#4. deploymentsuffix (used for sandboxing your proxies)

#Install jq dependency as a prerequisite for json parsing
#require zip installed on host running the script
#https://stedolan.github.io/jq/

#current_deployment_info=$(curl https://api.enterprise.apigee.com/v1/organizations/$org/environments/$env/apis/$proxyName$deploymentSuffix/deployments -u $apigeeUsername:$apigeePwd)

echo "********** Welcome !! Download the latest proxy version you edited on edge from here **********"


organization_default="eu-west1-partner26"
read -p "organization [$organization_default]:" organization
organization="${organization:-$organization_default}"
#organization=${organization:-eu-west1-partner26}


user_name_default="aakashsharm.aa5@hcl.com"
read -p "username [$user_name_default]:" user_name
user_name="${user_name:-$user_name_default}"

read -sp "password:" password

echo

deployment_suffix_default=""
read -p "deployment suffix (if any) [$deployment_suffix_default]:" deployment_suffix
deployment_suffix="${deployment_suffix:-$deployment_suffix_default}"


echo "Details provided: $organization $user_name $password $deployment_suffix"


#initially list out the revisions
#revisions_info=$(curl -i -o - --silent -u$user_name:$password "https://api.enterprise.apigee.com/v1/organizations/$organization/apis/my-apigee-api/revisions")
#revisions_response=$(curl --silent -w "HTTPSTATUS:%{http_code}" -u$user_name:$password "https://api.enterprise.apigee.com/v1/organizations/$organization/apis/my-apigee-api/revisions")
revisions_response=$(curl --silent -w "HTTPSTATUS:%{http_code}" -u$user_name:$password "https://api.enterprise.apigee.com/v1/organizations/$organization/apis/my-proxy-cabs2$deployment_suffix/revisions")

revisions_info=$(echo $revisions_response | sed -E 's/HTTPSTATUS\:[0-9]{3}$//')
STATUS=$(echo $revisions_response | tr -d '\n' | sed -E 's/.*HTTPSTATUS:([0-9]{3})$/\1/')

echo "revision information :$revisions_info"
echo "Status:$STATUS"

if [ $STATUS -ne 200 ]
then
echo "Unable to retreive proxy details from edge."
exit 1
fi


revisions_count=$(jq length <<< "${revisions_info}" ) 

echo "the revision count is:$revisions_count"

if [  -z "$revisions_count"  -o $revisions_count -eq 0 ]
then
	echo "revision not found for the proxy. Please check on apigee edge."
	exit 1

else

	#fetch the latest revision value from the revision count
	latest_revision=$(jq -r ".[-1]" <<<"${revisions_info}")

	echo "retreived the revision latest as: $latest_revision"

 #zippedProxyName = my_apigee_api+"$deployment_suffix_rev_$latest_revision.zip"
 zippedProxyFile="my-proxy-cabs2"$deployment_suffix"_rev_"$latest_revision".zip"
#zippedProxyFile="my-demo-cabs"$deployment_suffix"_rev_"$latest_revision".zip" 

#download the proxy
#curl -X GET -u$user_name:$password	 "https://api.enterprise.apigee.com/v1/organizations/$organization/apis/my-apigee-api/revisions/$latest_revision?format=bundle" -o zippedProxyName
curl -X GET -u$user_name:$password	 "https://api.enterprise.apigee.com/v1/organizations/$organization/apis/my-proxy-cabs2$deployment_suffix/revisions/$latest_revision?format=bundle" -o $zippedProxyFile
#unzip the proxy
unzip $zippedProxyFile

#message(success)
echo "***********************************"
echo "proxy revision downloaded from Edge successfully. you may verify your changes and commit to git"
echo "***********************************"

fi
#--End
