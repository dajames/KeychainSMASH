
(*

Help from: http://macscripter.net/viewtopic.php?id=24737
and from http://macscripter.net/viewtopic.php?id=42880
updated with help from http://macscripter.net/viewtopic.php?id=42929

*)


display dialog "We are going to trash your current local Keychain" with icon note buttons {"groovy", "lol, whu? NO!"} default button 1 cancel button 2

set punter to short user name of (system info)
-- fancy way of setting punter to logged in user

set pittedDate to do shell script "date '+%Y%m%d'"
-- this is a variable that puts todays date in an ASCII friendly way
-- such as 20140812

-- we're going to trash keychain settings
-- but to be safe, I am putting them in a folder on the desktop
-- i'm calling the variable 'Dumpster'
set Dumpster to punter & "_keychain_" & pittedDate

tell application "Finder"
	if exists folder Dumpster then
		delete every item of folder Dumpster
	else
		make new folder with properties {name:Dumpster}
	end if
end tell
-- we are going to yank out the keychain and toss it in our temporary dumpster
-- if the dumpster folder exists, already, this command will delete it


delay 1

-- now's the unforgiving part

try
	set keychainFolder to path to keychain folder
	try
		tell application "Finder" to set gaGa to name of first folder of keychainFolder
	end try
	-- if all goes correctly, this should be the long argle bargle folder with all annoying local settings
	-- has to be without administrator privileges.  I found doing it with admin privileges doesn't seem to to work correctly
end try


-- this also destroys all the login keychains as well

try
	do shell script "cp -R ~/Library/Keychains/" & gaGa & " ~/Desktop/" & Dumpster & "/" with administrator privileges
	do shell script "rm -rf ~/Library/Keychains/" & gaGa with administrator privileges
	do shell script "rm ~/Library/Keychains/login*" & gaGa with administrator privileges
end try


-- this destroys your Lync keychain.  Necessary, unfortunately.


try
	do shell script "rm -Rf " & UOFI & "/Library/Caches/com.microsoft.Lync/*" with administrator privileges
end try

try
	do shell script "rm -Rf " & UOFI & "/Library/Preferences/ByHost/MicrosoftLyncRegistrationDB*" with administrator privileges
end try

try
	do shell script "rm -Rf " & UOFI & "/Library/Preferences/com.microsoft.Lync*" with administrator privileges
end try

try
	do shell script "rm -Rf " & UOFI & "/Library/Keychains/OC_KeyContainer*" with administrator privileges
end try

-- ++++++++++++++++++++++++++++++++++++++++++++++++++
--- Lastly, we restart the whole process
-- ++++++++++++++++++++++++++++++++++++++++++++++++++


delay 1


set reRun to true
set reSpawn to "osascript -e 'tell app " & quote & "loginwindow" & quote & " to «event aevtrrst»'"

display dialog "Done.  Restart your Mac and restart Lync, and that will hopefully do it." with icon note buttons {"Restart Now.", "D'oh. Too Busy. Let's Do It Later."}
if result = {button returned:"Restart Now."} then
	try
		do shell script reSpawn with administrator privileges
	end try
else if result = {button returned:"D'oh. Too Busy. Let's Do It Later."} then
	display dialog "OK. Restart at your own leisure, but Lync won't work until you do." giving up after 3 with icon note buttons {"Okay.", "Super Okay."}
end if

