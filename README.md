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
