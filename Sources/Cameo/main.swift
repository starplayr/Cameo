//routes
import PerfectHTTP
import PerfectHTTPServer
import Foundation


public func routes() -> Routes {
    
    Config()
    
    //AutoLogin Routine to save time
    let autoUser = UserDefaults.standard.string(forKey: "user") ?? ""
    let autoPass = UserDefaults.standard.string(forKey: "pass") ?? ""
    
    //Auto Login the user
    if ( autoUser != "" && autoPass != "" && autoUser.count > 0 && autoPass.count > 0 ) {
        let returnData = Login(user: autoUser, pass: autoPass)
        
        if ( returnData.success ) {
            let userid = returnData.data;
            let _ = Session(channelid: "siriushits1", userid: userid)
            let _ = Channels(channeltype: "number", userid: userid)
            print("AutoLogin Success")
        }
    }

    var routes = Routes()
    
    // /key/1/{userid}
    routes.add(method: .get, uri:"/key/1/{userid}",handler:keyOneRoute)
    
    // /key/4/{userid}
    routes.add(method: .get, uri:"/key/4",handler:keyFourRoute)
    
    // /api/v2/login
    routes.add(method: .post, uri:"/api/v2/login",handler:loginRoute)
    
    // /api/v2/autologin
    routes.add(method: .post, uri:"/api/v2/autologin",handler:autoLoginRoute)
    
    // /api/v2/session
    routes.add(method: .post, uri:"/api/v2/session",handler:sessionRoute)
    
    // /api/v2/xtrasession
    routes.add(method: .post, uri:"/api/v2/xtras",handler:xtraSessionRoute)

    // /api/v2/xtrasession
    /*routes.add(method: .post, uri:"/api/v2/xtrs",handler:xtraTuneRoute)*/
    
    routes.add(method: .get, uri:"/xtras/**",handler:xtraPlaylistRoute)

    // /api/v2/channels
    routes.add(method: .post, uri:"/api/v2/channels",handler:channelsRoute)
    
    // /playlist/{userid}/2.m3u8
    routes.add(method: .get, uri:"/playlist/{userid}/**",handler:playlistRoute)
    
    // /audio/{userid}/**.aac
    routes.add(method: .get, uri:"/audio/{userid}/**",handler:audioRoute)
    
    // /clips/**
    routes.add(method: .get, uri:"/xtraAudio/**",handler:xtraAudioRoute)
    
    // /PDT (artist and song data)
    routes.add(method: .get, uri:"/pdt/{userid}",handler:PDTRoute)
    
    // /ping (return is pong) This is way of checking if server is running
    routes.add(method: .get, uri:"/ping",handler:pingRoute)
    
    // Check the console to see the logical structure of what was installed.
    //  print("\(routes.navigator.description)")
    
    return routes
    
}


let server = HTTPServer()
server.serverAddress = Global.variable.ipaddress
server.serverPort = UInt16(Global.variable.port)



do {
    server.addRoutes( routes() )
    try server.start()
} catch {
    print("There was an issue starting the server.")
}
