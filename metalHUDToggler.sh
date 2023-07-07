#!/bin/bash
bottlename=Steam
user=$(whoami)
title="Crossover Metal HUD Toggler"

dialog=""

# Check if cxbottle.conf exists
if [ ! -f /Users/$user/Library/Application\ Support/CrossOver/Bottles/$bottlename/cxbottle.conf ]; then
    dialog="cxbottle.conf does not exist for $bottlename"
    icon="stop"
    # Create a system event to inform user that cxbottle.conf does not exist
/usr/bin/osascript <<-EOF
    tell application "System Events"
        activate
        display dialog "$dialog" buttons {"OK"} default button 1 with title "$title" with icon caution
    end tell
EOF
    exit 1
fi

# Send dialog having user decide if they want to enable Metal HUD or not and then enable/disable it
lastLine_CX_Congig=$(tail -1 /Users/$user/Library/Application\ Support/CrossOver/Bottles/$bottlename/cxbottle.conf)

dialogResult=$(/usr/bin/osascript <<-EOF
    tell application "System Events"
        activate
        display dialog "Do you want to enable Metal HUD for $bottlename?" buttons {"Yes", "No"} default button 1 with title "$title"
    end tell
EOF)

if [ "$dialogResult" == "button returned:Yes" ]; then
    dialog="Metal HUD is enabled for $bottlename"

    if [[ $lastLine_CX_Congig != *'"MTL_HUD_ENABLED" = "1"'* ]]; then
        echo '"MTL_HUD_ENABLED" = "1"' >> /Users/$user/Library/Application\ Support/CrossOver/Bottles/$bottlename/cxbottle.conf        
    fi
else
    dialog="Metal HUD is disabled for $bottlename"

    if [[ $lastLine_CX_Congig == *'"MTL_HUD_ENABLED" = "1"'* ]]; then
        sed -i '' -e '$ d' /Users/$user/Library/Application\ Support/CrossOver/Bottles/$bottlename/cxbottle.conf    
    fi
fi

cmd='display notification "'$dialog'" with title "'$title'"'
osascript -e "$cmd"