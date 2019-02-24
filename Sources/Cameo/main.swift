import PerfectHTTP
import PerfectHTTPServer
import Foundation

Config()

let server = HTTPServer()
server.serverAddress = Global.variable.ipaddress
server.serverPort = UInt16(Global.variable.port)



public func routes() -> Routes {
    
    //read from MemBase
    /*
     if let readMemBase = UserDefaults.standard.data(forKey:  "MemBase") {
     let readData = NSKeyedUnarchiver.unarchiveObject(with: readMemBase)
     Global.variable.MemBase = readData as! [String : Any]
     }
     */
    var routes = Routes()
    
    // /key/1/{userid}
    routes.add(method: .get, uri:"/key/1/{userid}",handler:keyOneRoute)
    
    // /key/4/{userid}
    routes.add(method: .get, uri:"/key/4/{userid}",handler:keyFourRoute)
    
    // /autobox (login, session, channels)
    routes.add(method: .post, uri:"/api/v2/autobox",handler:autoBox)
    
    // /api/v2/login
    routes.add(method: .post, uri:"/api/v2/login",handler:loginRoute)
    
    // /api/v2/session
    routes.add(method: .post, uri:"/api/v2/session",handler:sessionRoute)
    
    // /api/v2/channels
    routes.add(method: .post, uri:"/api/v2/channels",handler:channelsRoute)
    
    // /playlist/{userid}/2.m3u8
    routes.add(method: .get, uri:"/playlist/{userid}/**",handler:playlistRoute)
    
    // /audio/{userid}/2.m3u8
    routes.add(method: .get, uri:"/audio/{userid}/**",handler:audioRoute)
    
    // /PDT (artist and song data)
    routes.add(method: .get, uri:"/pdt/{userid}",handler:PDTRoute)
    
    // Check the console to see the logical structure of what was installed.
    //  print("\(routes.navigator.description)")
    return routes
    
}


do {
    server.addRoutes( routes() )
    try server.start()
} catch {
   print("There was an issue starting the server.")
}
