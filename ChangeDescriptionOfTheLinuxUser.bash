#Command to run this script is "./ChangeDesc-BashScript.bash > /dev/null 2>&1"
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#=======================Extraction of attributes of the system====================================================================================================================================
#Extract the product name of the Computer
product=$(sudo lshw -c system | grep product |sed 's/^.*product: //')
#Extract the serial name of the Computer
serial=$(sudo lshw -c system | grep serial |sed 's/^.*serial: //')
#Extract the Last logon user name of the Computer
lastlogonuser=$(last -w| head -n 1 | awk {'print $1'})
#Extract the last logon date of the Computer
userlastdate=$(last -1 -F |awk '{if(NR==1) print $0}' | awk {'print $5" " $6" " $8'})
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#=======================Set the Description Textfield of the computer==============================================================================================================================
# Extract Computer name of the system
comp_name=$(hostname)

#Extract the Object of the computer from the Active Directory
out=$(/opt/pbis/bin/adtool -a search-computer --search-base DC=fulton,DC=ad,DC=asu,DC=edu --scope subtree --name "$comp_name")

#Format the Extracted Object
out2=$(echo "$out" | head -n 1)

#Set the Description of the computer
out1=$(/opt/pbis/bin/adtool -a set-attr --dn="$out2" --attrName description --attrValue "$product,$serial,$lastlogonuser,$userlastdate")

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
