#!/bin/bash


# PLEASE READ THIS FIRST!!!:
#	1. THIS SCRIPT IS A ZOOM NOTIFICATION UPDATE WHICH CHECKS IF THE USER HAS AN OLDER VERSION OF ZOOM, THEN THE NOTIFICATION PROMPTS THE USER 
#	   TO PRESS "OK" OR "LATER" OR THE "SELF-SERVICE ICON". IF PRESS "OK" OR THE "ICON", IT UPDATES AND RESTARTS ZOOM STRAIGHT AHEAD,
#	   ELSE THE NOTIFICATION WILL POP UP AGAIN AFTER x SECONDS. THE USER CAN PRESS "LATER" MAXIMUM x TIMES
#	2. THE SCRIPT SHOULD BE LOCATED IN THE APPLICATION FOLDER AND IT WILL DELETED AUTOMATICALLY WHEN THE PROCESS IS FINISHED
#	3. THE SCRIPT SHOULD START BEFORE AND WITH THE POLICY ID WHICH IT CALLS OR SHOULD RUN AS A SEPARATE POLICY
#	  (THE SCRIPT SHOULD RUN FIRST SO BE CAREFUL HOW YOU WILL CALL THE NEW POLICY - JAMF WORKS WITH ALPHABETICAL ORDER)
#	4. THE SCRIPT'S CODE DOES NOT NEED TO INCLUDE "SUDO JAMF RECON" AS JAMF CAN SET UP THIS IN THE POLICY VIA THE MAINTENANCE SECTOR (UPDATE INVENTORY)


#Version of the application
VERSION=$(defaults read /Applications/zoom.us.app/Contents/Info.plist CFBundleShortVersionString)

#If the current is old then start the process
if [[ "$VERSION" = "5.0.0 (23186.0427)" ]]; then

    echo "Current version" $VERSION ",this version is old and a new update is available!"

    #Flag is a boolean variable which will declare when the loop should end
    flag=false

    #Count how many times the user can press "LATER"
    count=3

    #Loop runs as long as flag is FALSE. NOTE: If the user pressed "LATER" 3 times, then flag changes to TRUE.
    while [ "$flag" = false ]
    do

        if [ "$count" -eq 0 ]; then
            #Notification's GUI. If the user pressed 3 times "LATER", the "LATER" option is gone
            Result=` alerter -sender "com.jamfsoftware.selfservice.mac" -title "There's a new version of Zoom" -message "To Update (and restart Zoom). Just click this notification!" -sound default -closeLabel ↓ -actions "Ok"`

        else
            #Notification's GUI
            Result=` alerter -sender "com.jamfsoftware.selfservice.mac" -title "There's a new version of Zoom" -message "To Update (and restart Zoom). Just click this notification, $count attemp(s) left!" -sound default -closeLabel Ok -actions "Later"`
        fi

              #If the users selects "OK" or has already pressed "LATER" 3 times then
              if [[ "$Result" = "Ok" ]] || [ "$count" -eq 0 ]; then

                #Run install policy, close Zoom, and update the inventory
                echo "User selected OK"
                sudo jamf policy -id "add the policy id without the brackets"
                killall zoom.us
                open /Applications/zoom.us.app
                flag=true

              #If the users selects the "ICON" or has already pressed "LATER" 3 times then
              elif [[ "$Result" = "@CONTENTCLICKED" ]] || [ "$count" -eq 0 ]; then

                #Run install policy, close Zoom, and update the inventory
                echo "User selected the ICON"
                sudo jamf policy -id "add the policy id without the brackets"
                killall zoom.us
                open /Applications/zoom.us.app
                flag=true


              else

                #Run the Policy again in x sec (max 3 times)
                echo "User selected to delayed the installation"
                ((count--))
                sleep 5

              fi

          done

        else

        echo "No update needed,current version" $VERSION

fi

#Remove the Script from its location as it is not useful anymore
rm /Applications/Zoom_Notification.sh

exit 0

#Signature: Georgios Karanasios and Michael Williams 05/04/2020
