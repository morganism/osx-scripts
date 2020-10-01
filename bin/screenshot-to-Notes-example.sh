
echo "take a silent screenshot AND open a new Note AND create a new note AND insert the screenshot
screencapture -xc && open -na Notes && osascript -e 'tell application "Notes" to activate' && osascript -e 'tell application "System Events" to keystroke "n" using {command down}' && osascript -e 'tell application "System Events" to keystroke "v" using {command down}'
