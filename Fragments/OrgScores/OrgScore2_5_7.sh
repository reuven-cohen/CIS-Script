#!/bin/zsh

script_dir=$(dirname ${0:A})
projectfolder=$(dirname $script_dir)

source ${projectfolder}/Header.sh

CISLevel="2"
audit="2.5.7 Audit Camera Privacy and Confidentiality (Manual)"
orgScore="OrgScore2_5_7"
emptyVariables
# Verify organizational score
runAudit
# If organizational score is 1 or true, check status of client
if [[ "${auditResult}" == "1" ]]; then
	method="Profile"
	remediate="Configuration profile - payload > com.apple.applicationaccess > allowCamera=true or false"

	getCameraStatus=$(sudo /usr/bin/profiles -P -o stdout | /usr/bin/grep allowCamera) #(0 = Disabled, 1 = Enabled)
	if [[ "${getCameraStatus}" == "0" ]]; then
		result="Notice"
		comment="Camera is Disabled"
	else 
		result="Notice"
		comment="Camera is Enabled"
	fi
fi
printReport
