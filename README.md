# Cameo

Is a lean HTTP Live Streaming engine and currently supports for streaming Sirius XM Radio. Other radio and video services are planned. Cameo works directly with StarPlayrX, our flag ship streaming internet radio player currently in early stage development. Cameo works with AVKit, Quicktime, Mplayer, FFMPEG, VLC. So far it works best with AVKit / AVPlayer which is what StarPlayr will be on macOS, iOS, tvOS and watchOS.  We are looking for equivalent frameworks for Android, Windows and Linux.

Cameo uses Perfect HTTP Server for its backend. Perfect is fast, stable and powerful. If you prefer Kitura, Vapor or another server side swift framework, you should be able to transcode the Routing and Server area of the app (main.swift and Routing.swift). Cameo may turn into a generic library in the near future with the router and server as separate libraries to support Vapor, Kitura and other frameworks in the future. The Cameo Engine (owned by Todd Bruss aka starplayr) will remain plain vanilla Swift. Cameo is agile and can be adapted to anything that supports Swift and the Foundaiton framework. There is a Linux port of Foundation by Swift.org.parted

Cameo currently runs on macOS. We have not tested other platforms yet. The goal is Linux, iOS, Android, tvOS, watchOS, Windows and Raspberry Pi.

## API To Do List (subject to change):
```swift
x Multi user support. done
Artist / Song data / PDT
Channel List via CLI
Convenience methods
Web UI
Offline content
Voice support
```

API Updated to V2
More Convience methods will be added soon.

## Perfect Server
```swift
ipaddress and port is located in Global.swift
```

## Command line instructions
```swift
cd Camo*
swift update packages
swift build
swift run
```

## Step 1 Sirius XM Login (Account Required)
```swift
curl -d '{"user":"email@addr.com", "pass":"x"}' -H "Content-type: application/json" -X POST http://127.0.0.1:1111/api/v2/login

//userid is returned in the data string. It is used on session,channels,and playlist calls. It helps if you are testing more than one SiriusXM account.  
```

## Step 2 Session (Establishes the Session between SiriusXM and Cameo)
```swift
curl -d '{"channelid":"siriushits1", "userid":"x"}' -H "Content-type: application/json" -X POST http://127.0.0.1:1111/api/v2/session
```

## Step 3 Channels (Pulls channels by number. If using MPlayer in the commmand line simply ignore its output.)
```swift
curl -d '{"channeltype":"number","userid":"x"}' -H "Content-type: application/json" -X POST http://127.0.0.1:1111/api/v2/channels
```

## Step 4 Playlist by channel number and play through mplayer
```swift
mplayer http://localhost:1111/playlist/{userid}/2.m3u8 -cache 32
```
The userid was addded to support multi users from the backend. Cameo's goal is to support multiple Radio and Video platforms.
Our m3u8 playlists work with mplayer, VLC, Apple's AVKit's AVPlayer, Apple's Quicktime Player. It does not support iTunes. This API is designed to work with StarPlayrX, our flag ship app in early development. Cameo will be revised for more common usage along with a Web User Interface.
