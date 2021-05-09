# Notification BashScript Project - Zoom Update Sample
This Bash Script is a notification update and can be used for any Desktop Support team that uses JAMF policies to update macOS applications. In this case, it checks if the user has an older version of Zoom. Then, the notification prompts to press "OK" or "LATER" or the "Self-Service icon". If he presses "OK" or the "ICON", it updates Zoom straight ahead, else the notification will pop up again after "x" seconds. When the process is finished, the script is deleted by itself. The user can press "LATER" maximum "x" times.

NOTE: This is just for testing purposes!

# How to run it
1. In the Terminal app on your Mac, use the Enter the chmod command to make the file executable. For example: 

   chmod 755 /Applications/Zoom_Notification.sh
   
2. After making the shell script file executable, you can run it by entering its pathname. For example:

   /Applications/Zoom_Notification.sh
   
# Video link (Includes an older version of this script)
https://youtu.be/pD9Z_ktL__I
