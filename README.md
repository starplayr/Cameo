# Cameo

Is a lean HTTP Live Streaming engine and currently supports for streaming Sirius XM Radio. Other radio and video services are planned. Cameo works directly with StarPlayrX, our flag ship streaming internet radio player currently under concurrent development. Cameo works with AVKit, Quicktime, Mplayer, FFMPEG, VLC. So far it works best with AVKit / AVPlayer which is what StarPlayr will be on macOS, iOS, tvOS and watchOS.  We are looking for equivalent frameworks for Android, Windows and Linux.

Cameo uses Perfect HTTP Server for its backend. Perfect is fast, stable and powerful. If you prefer Kitura, Vapor or another server side swift framework, you should be able to transcode the Routing and Server area of the app (main.swift and Routing.swift). Cameo may turn into a generic library in the near future with the router and server as separate libraries to support Vapor, Kitura and other frameworks in the future. The Cameo Engine (the parted owned by starplayr) will remain plain vanilla Swift. Cameo is agile and can be adapted to anything that supports Swift and the Foundaiton framework. There is a Linux port of Foundation by Swift.org.

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
ipaddress and port is in Global.swift
default to 127.0.0.1 for localhost
use your computer's IP if you plan on testing external devices on your LAN like iOS.
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
curl -d '{"user":"email@addr.com", "pass":"xxxxxx"}' -H "Content-type: application/json" -X POST http://127.0.0.1:1111/api/v2/login

returns data string which becomes the userid in Session,Channels, and Playlist calls.
we will be adding a epoche number soon to this userid. It will be a tad long, but its management will all be handled through StarPlayrX or equvilant. We may add in the option to assign your own UserID at login to simplify the process. We chose not to use the user's email address for the userid for security purposes.  
```

## Step 2 Session (Establishes the Session between SiriusXM and Cameo)
```swift
curl -d '{"channelid":"2", "userid":"xxxxxx"}' -H "Content-type: application/json" -X POST http://127.0.0.1:1111/api/v2/session
```

## Channels (Pulls channels by number)
```swift
curl -d '{"channeltype":"number","userid":"xxxxxx"}' -H "Content-type: application/json" -X POST http://127.0.0.1:1111/api/v2/channels
```

## Playlist by channel number and play through mplayer
```swift
mplayer http://localhost:1111/playlist/{userid}/2.m3u8 -cache 32
```

The userid was addded to support multi users from the backend. Cameo's goal is to support multiple Radio and Video platforms.
Our m3u8 playlists work with mplayer, VLC, Apple's AVKit's AVPlayer, Apple's Quicktime Player. It does not support iTunes. This API is designed to work with StarPlayrX. It will be revised for more common usage along with a Web User Interface.
