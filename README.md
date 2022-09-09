## What

Two versions for the same script to toggle the speed limits via [qBittorrent WebUI API](<https://github.com/qbittorrent/qBittorrent/wiki/WebUI-API-(qBittorrent-4.1)>).  
Pick just one.

## How

First you need to edit the script you choose and change the url and credentials (if you are not bypass them).  
To run both scripts you need to tell what you want to do:

- bash `./qbit_toggle_speed.sh enable` and `./qbit_toggle_speed.sh disable`
- python `python3 qbit_toggle_speed.py --action enable` and `python3 qbit_toggle_speed.py --action disable`

## Tautulli setup

Use Tautulli notifications agent to determine when to trigger them. This way you slow qbit when streaming.  
You need to have access to the script in the file system, it is easier to add it to your config folder.

> **Note**
> If you choose the bash version check user and permisions.

1. Go to `Tautulli Settings > Notification Agents` add click in `Add a new notification agent`
1. Select `Script`
1. Under `Script Folder` you select the folder that contain the script
1. `Script File` you select the script
1. Add a description like `play = enable speed limit` since we're gonna the stop version later
1. Go to `Triggers`
   - Pick `Playback Start`
1. Go to `Conditions`:
   1. Condition {1}
      - --Parameter-- set to `Streams`
      - --Operator-- set to `is`
      - --Value-- set to `1`
1. Go to `Arguments`
   - Click in `Playback Start` and set the `Script Arguments`:
     - If you're using the bash version, set to `enable`
     - If you're using the python version, set to `--action enable`
1. Save

We need to repeat it to create (or duplicate) another to **trigger when stop** stream to disable the speed limit.  
The reason we need two notifications is because we are using Tautulli conditions to match number of stream with the action.

1. Add a description like `stop = disable speed limit`
1. Go to `Triggers`
   - Pick `Playback Stop` ⚠️
1. Go to `Conditions`:
   1. Condition {1}
      - --Parameter-- set to `Streams`
      - --Operator-- set to `is`
      - --Value-- set to `0` ⚠️
1. Go to `Arguments`
   - Click in `Playback Stop` ⚠️ and set the `Script Arguments`:
     - If you're using the bash version, set to `disable` ⚠️
     - If you're using the python version, set to `--action disable` ⚠️
1. Save
