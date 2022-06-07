#!/bin/zsh

script_dir=$(dirname ${0:A})
projectfolder=$(dirname $script_dir)

source ${projectfolder}/Header.sh

CISLevel="2"
audit="2.3.2 Ensure Screen Saver Corners Are Secure (Automated)"
orgScore="OrgScore2_3_2"
emptyVariables
# Verify organizational score
runAudit
# If organizational score is 1 or true, check status of client
if [[ "${auditResult}" == "1" ]]; then
	method="Profile"
	remediate="Configuration profile - payload > com.apple.dock > wvous-tl-corner=5, wvous-br-corner=10, wvous-bl-corner=13, wvous-tr-corner=0 - 5=Start Screen Saver, 10=Put Display to Sleep, 13=Lock Screen"

	appidentifier="com.apple.dock"
	value="wvous-bl-corner"
	value2="wvous-tl-corner"
	value3="wvous-tr-corner"
	value4="wvous-br-corner"
	prefValueAsUser=$(getPrefValuerunAsUser "${appidentifier}" "${value}")
	prefValue2AsUser=$(getPrefValuerunAsUser "${appidentifier}" "${value2}")
	prefValue3AsUser=$(getPrefValuerunAsUser "${appidentifier}" "${value3}")
	prefValue4AsUser=$(getPrefValuerunAsUser "${appidentifier}" "${value4}")
	prefIsManaged=$(getPrefIsManagedrunAsUser "${appidentifier}" "${value}")
	prefIsManaged2=$(getPrefIsManagedrunAsUser "${appidentifier}" "${value2}")
	prefIsManaged3=$(getPrefIsManagedrunAsUser "${appidentifier}" "${value3}")
	prefIsManaged4=$(getPrefIsManagedrunAsUser "${appidentifier}" "${value4}")
    comment="Secure screen saver corners: enabled"
    	if [[ "${prefIsManaged}" == true ]] || [[ "${prefIsManaged2}" == true ]] || [[ "${prefIsManaged3}" == true ]] || [[ "${prefIsManaged4}" == true ]]; then
    		prefIsManaged="true"
    	else
    		prefIsManaged="false"
    	fi
	if [[ "${prefValueAsUser}" != "6" ]] && [[ "${prefValue2AsUser}" != "6" ]] && [[ "${prefValue3AsUser}" != "6" ]] && [[ "${prefValue4AsUser}" != "6" ]]; then
		result="Passed"
	else
		result="Failed"
		comment="Secure screen saver corners: Disabled"
        # Remediation
		if [[ "${remediateResult}" == "enabled" ]]; then
			/usr/bin/sudo -u "${currentUser}" /usr/bin/defaults delete /Users/"${currentUser}"/Library/Preferences/com.apple.dock wvous-bl-corner 2>/dev/null
            		/usr/bin/sudo -u "${currentUser}" /usr/bin/defaults delete /Users/"${currentUser}"/Library/Preferences/com.apple.dock wvous-tl-corner 2>/dev/null
            		/usr/bin/sudo -u "${currentUser}" /usr/bin/defaults delete /Users/"${currentUser}"/Library/Preferences/com.apple.dock wvous-tr-corner 2>/dev/null
            		/usr/bin/sudo -u "${currentUser}" /usr/bin/defaults delete /Users/"${currentUser}"/Library/Preferences/com.apple.dock wvous-br-corner 2>/dev/null
			# re-check
			prefValueAsUser=$(getPrefValuerunAsUser "${appidentifier}" "${value}")
			prefValue2AsUser=$(getPrefValuerunAsUser "${appidentifier}" "${value2}")
			prefValue3AsUser=$(getPrefValuerunAsUser "${appidentifier}" "${value3}")
			prefValue4AsUser=$(getPrefValuerunAsUser "${appidentifier}" "${value4}")
			if [[ "${prefValueAsUser}" != "6" ]] && [[ "${prefValue2AsUser}" != "6" ]] && [[ "${prefValue3AsUser}" != "6" ]] && [[ "${prefValue4AsUser}" != "6" ]]; then
				result="Passed After Remediation"
				comment="Secure screen saver corners: enabled"
			else
				result="Failed After Remediation"
			fi
		fi
	fi
fi
value="${value}, ${value2}, ${value3}, ${value4}"
prefValue="${prefValueAsUser}, ${prefValue2AsUser}, ${prefValue3AsUser}, ${prefValue4AsUser}"
printReport
