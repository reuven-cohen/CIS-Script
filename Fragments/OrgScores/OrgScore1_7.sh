#!/bin/zsh

script_dir=$(dirname ${0:A})
projectfolder=$(dirname $script_dir)

source ${projectfolder}/Header.sh

CISLevel="2"
audit="1.7 Audit Computer Name (Manual)"
orgScore="OrgScore1_7"
emptyVariables
# Verify organizational score
runAudit
# If organizational score is 1 or true, check status of client
if [[ "${auditResult}" == "1" ]]; then
	method="Manual"
	remediate="Manual - sudo /usr/sbin/scutil --get ComputerName | sudo /usr/sbin/scutil --get LocalHostName | sudo /usr/sbin/scutil --get HostName"

	getComputerName=$(sudo /usr/sbin/scutil --get ComputerName)
	getLocalHostName=$(sudo /usr/sbin/scutil --get LocalHostName)
  getHostName=$(sudo /usr/sbin/scutil --get HostName)
	if [[ "${getComputerName}" != "0" ]]; then
		result="Notice"
		comment="ComputerName = $getComputerName , LocalHostName = $getLocalHostName , HostName = $getHostName"
	else 
		result="Notice"
		comment="ComputerName = $getComputerName , LocalHostName = $getLocalHostName , HostName = $getHostName"
	fi
fi
printReport
