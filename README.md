# SteamGameRecStream2Container
## Convert the raw stream saved by the Steam Game Recording into an mp4 container

Basically, Steam Game Recording saves the recording as a raw, chunked streams of audio and video.
This script takes the chunks and combines it into one mp4 container with whole video and audio streams.

## Step by step nerd explanation of what it does
1. Create an output folder
2. Loop for each video stream chunk in current directory:
   1. Convert video stream chunk into an mp4 container
   2. Log the file into a text file for later
   3. Remux the newly made mp4 container to remove the container timing
   4. Do the same for the audio stream
3. Use the text file containing the file names of the video chunks to combine all chunks into one mp4
4. do the same for audio chunks
5. combine both video mp4 and audio mp4 to create an mp4 with both

## how 2 use
1. find where Steam Game Recordings are saved
   - usually under ``/home/<user>/.local/share/Steam/userdata/<AccountID>/gamerecordings/<video/clips>/<recording type>_<AppID>_<date in YYYYMMDD>_<time in HHMMSS>/`` or wherever you set it to in Steam settings
2. put the script where the recording data is, if you see m4s files in there you're in the right place
3. execute

be aware that you should have at least 2 times the size of the raw recording in free space
- if recording is 20GB, make sure you have 40GB free

## gotta figure out
if adding microphone recording adds a 2nd audio stream or does it get saved in the gameplay audio stream
