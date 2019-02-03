# Cameo

An HTTP Live Streaming Engine for Sirius XM Radio. Other radio and video services will be added down the road. Cameo works directly with StarPlayrX, our flag ship streaming internet radio player, but its generic enough to run in any player that support HLS over HTTP.

Cameo, formerly Camouflage, is an HTML Live Streaming Engine currently designed to work with Sirius XM Radio. It fully supports the Swift Package Manager 4.2. We've updated and it currently working with Perfect's HTTP Live Server which we are having an awesome time with it. If you are using Kitura or Vapor, just only thing you will need to change is the Server and Routing layers (2 files). Cameo, it built using plain vanilla flavored Swift 4.2.1

Cameo currently runs on macOS. We have not tested in on other platforms yet, but we will be bringing it to Linux, iOS, Android, tvOS, watchOS, Windows and Raspberry Pi.

Camo uses Perfect's HTTP Server for its backend. The Camo framework is very lightweight. It compiles to 1.1MB and uses only 24MB RAM while streaming, it uses Zero CPU and has Zero Energy impact. Zero Disk, and Low Network while streaming.

API Updated to V2
More Convience methods will be added soon.

## Perfect Server
```swift
let server = HTTPServer()
server.serverAddress = "127.0.0.1"
server.serverPort = 1111
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
curl -d '{"user":"emaill@addr.com", "pass":"xxxxxx"}' -H "Content-type: application/json" -X POST http://localhost:1111/api/v2/login
```

## Step 2 Session
```swift
curl -d '{"channelid":"siriushits1"}' -H "Content-type: application/json" -X POST http://localhost:1111/api/v2/session
```

## Channels (Pulls channels by number)
```swift
curl -d '{"channelType":"number"}' -H "Content-type: application/json" -X POST http://localhost:1111/api/v2/channels
```

## Playlist by channel number
```swift
http://localhost:1111/playlist/2.m3u8
```

Our m3u8 playlists work with mplayer, VLC, Apple's AVKit's AVPlayer, Apple's Quicktime Player. It does not support iTunes. 32k Cache is recommended with mplayer.

This API is designed to work with StarPlayrX. It will be revised for more common usage along with a Web User Interface.
