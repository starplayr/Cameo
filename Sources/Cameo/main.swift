import PerfectHTTP
import PerfectHTTPServer
import Foundation

Config()

let server = HTTPServer()
server.serverAddress = Global.variable.ipaddress
server.serverPort = UInt16(Global.variable.port)



private func routes() -> Routes {
    
    var routes = Routes()

    // /key/1
    routes.add(method: .get, uri:"/key/1",handler:keyOneRoute)
    
    // /api/v2/login
    routes.add(method: .post, uri:"/api/v2/login",handler:loginRoute)
    
    // /api/v2/session
    routes.add(method: .post, uri:"/api/v2/session",handler:sessionRoute)
    
    // /api/v2/channels
    routes.add(method: .post, uri:"/api/v2/channels",handler:channelsRoute)
    
    // /playlist/2.m3u8
    routes.add(method: .get, uri:"/playlist/**",handler:playlistRoute)
    
    // /audio/2.m3u8
    routes.add(method: .get, uri:"/audio/**",handler:audioRoute)
    
    // Check the console to see the logical structure of what was installed.
    print("\(routes.navigator.description)")
    return routes
    
}

do {
    server.addRoutes( routes() )
    try server.start()
} catch {
   print("There was an issue starting the server.")
}
