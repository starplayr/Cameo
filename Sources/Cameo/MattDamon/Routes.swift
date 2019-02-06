import PerfectHTTP
import PerfectHTTPServer
import Foundation

//key/1/{userid}
internal func keyOneRoute(request: HTTPRequest, _ response: HTTPResponse) {
    var key : String? = "" //default to empty string
    let userid = request.urlVariables["userid"]
    
    if  userid != nil && Global.variable.user[userid!]!.key.count > 1 {
        key = Global.variable.user[userid!]!.key
    }
    
    response.setBody(bytes: [UInt8](Data(base64Encoded: key!)!))
        .setHeader(.contentType, value:"application/octet-stream")
        .completed()
    key = nil
}

internal func PDTRoute(request: HTTPRequest, _ response: HTTPResponse) {
    let data = PDT()
    let jayson = ["data": "mockdata", "message": "mockreturn", "success": true] as [String : Any]
    try? _ = response.setBody(json: jayson)
    response.setHeader(.contentType, value:"application/json")
    response.completed()
}

//login
internal func loginRoute(request: HTTPRequest, _ response: HTTPResponse)  {
    
    if let body = request.postBodyString {
        
        do {
            let json = try body.jsonDecode() as? [String:Any]
            let user = json?["user"] as? String ?? ""
            let pass = json?["pass"] as? String ?? ""
            
            if user != "" && pass != "" {
                //Login func
                let returnData = Login(user: user, pass: pass)
                let jayson = ["data": returnData.data, "message": returnData.message, "success": returnData.success] as [String : Any]
                try? _ = response.setBody(json: jayson)
                response.setHeader(.contentType, value:"application/json")
                response.completed()
            } else {
                let jayson = ["data": "", "message": "Missing username or password / 'user' or 'pass' key.", "success": false] as [String : Any]
                try? _ = response.setBody(json: jayson)
                response.setHeader(.contentType, value:"application/json")
                response.completed()
            }
            
        } catch {
            let jayson = ["data": "", "message": "Syntax Error or invalid JSON", "success": false] as [String : Any]
            try? _ = response.setBody(json: jayson)
            response.setHeader(.contentType, value:"application/json")
            response.completed()
        }
        
    } else {
        let jayson = ["data": "", "message": "To error is human, login failed.", "success": false] as [String : Any]
        try? _ = response.setBody(json: jayson)
        response.setHeader(.contentType, value:"application/json")
        response.completed()
    }
}

//session
internal func sessionRoute(request: HTTPRequest, _ response: HTTPResponse) {
    
    if let body = request.postBodyString {
        
        do {
            let json = try body.jsonDecode() as? [String:Any]
            let channelid = json?["channelid"] as? String ?? ""
            let userid = json?["userid"] as? String ?? ""

            if channelid != "" && userid != "" {
                //Session func
                let returnData = Session(channelid: channelid, userid: userid)
                let jayson = ["data": returnData, "message": "coolbeans", "success": true] as [String : Any]
                try? _ = response.setBody(json: jayson)
                    .setHeader(.contentType, value:"application/json")
                    .completed()
            } else {
                let jayson = ["data": "", "message": "Missing channelid, userid or key.", "success": false] as [String : Any]
                try? _ = response.setBody(json: jayson)
                    .setHeader(.contentType, value:"application/json")
                    .completed()
            }
        } catch {
            let jayson = ["data": "", "message": "Syntax Error or invalid JSON.", "success": false] as [String : Any]
            try? _ = response.setBody(json: jayson)
                .setHeader(.contentType, value:"application/json")
                .completed()
        }
        
    } else {
        let jayson = ["data": "", "message": "Session may be invalid, try logging in first.", "success": false] as [String : Any]
        try? _ = response.setBody(json: jayson)
            .setHeader(.contentType, value:"application/json")
            .completed()
    }
}

//channels
internal func channelsRoute(request: HTTPRequest, _ response: HTTPResponse) {
    
    if let body = request.postBodyString {
        
        do {
            let json = try body.jsonDecode() as? [String:Any]
            let channeltype = json?["channeltype"] as? String ?? ""
            let userid = json?["userid"] as? String ?? ""

        
            if channeltype != "" && userid != "" {
                //Session func
                let returnData = Channels(channeltype: channeltype, userid: userid)
                
                let jayson = ["data": returnData.data, "message": "coolbeans", "success": true] as [String : Any]
                try? _ = response.setBody(json: jayson)
                response.setHeader(.contentType, value:"application/json")
                .completed()
            } else {
                let jayson = ["data": "", "message": "Missing a ChannelType, or key. Try SiriusXM", "success": false] as [String : Any]
                try! response.setBody(json: jayson)
                response.setHeader(.contentType, value:"application/json")
                .completed()
            }
        } catch {
            let jayson = ["data": "", "message": "Syntax Error, invalid JSON.", "success": true] as [String : Any]
            try? _ = response.setBody(json: jayson)
            response.setHeader(.contentType, value:"application/json")
                .completed()
        }
       
    } else {
        let jayson = ["data": "", "message": "Session may be invalid, try logging in first.", "success": false] as [String : Any]
        try? _ = response.setBody(json: jayson)
        response.setHeader(.contentType, value:"application/json")
        .completed()
    }
}


//playlist
internal func playlistRoute(request: HTTPRequest, _ response: HTTPResponse) {
    let playlistRequest = request.urlVariables[routeTrailingWildcardKey]
    let userid = request.urlVariables["userid"]
    let filename = String(playlistRequest!.dropFirst())
    let channelArray = filename.split(separator: ".")
    
    var channel : String? = ""
    
    if channelArray.count > 1 {
        channel = String(channelArray[0])
    }
    
    if channel!.count > 0 && userid != nil && playlistRequest != nil {
        
        
        if let ch = Global.variable.user[(userid)!]?.channels[channel!]! as? NSDictionary {
            let channelid = ch["channelId"] as? String
            
            if channelid != Global.variable.user[userid!]!.channel {
                Global.variable.streaming = false;
            } else {
                Global.variable.streaming = true;
            }
            
            Global.variable.user[userid!]!.channel = channelid!
            
            //run to start
            if !Global.variable.streaming {
                _ = Session(channelid: channelid!, userid: userid!)
            }
            
            if channelid != nil && userid != nil {
                let playlist = Playlist(channelid: channelid!, userid: userid!)
                response.setBody(string: playlist)
                    .setHeader(.contentType, value:"application/x-mpegURL")
                    .completed()

                //then trail for remaining to speed up time
                if Global.variable.streaming {
                    let xxx = Session(channelid: channelid!, userid: userid!)
                }
                
            } else {
                response.setBody(string: "Channel is missing.\n\r")
                    .setHeader(.contentType, value:"text/plain")
                    .completed()
            }
            
           
        } else {
            response.setBody(string: "The channel does not exist.\n\r")
                .setHeader(.contentType, value:"text/plain")
                .completed()
        }
    } else {
        response.setBody(string: "Incorrect Parameter.\n\r")
        .setHeader(.contentType, value:"text/plain")
        .completed()
    }
}

internal func audioRoute(request: HTTPRequest, _ response: HTTPResponse) {
    let audio = request.urlVariables[routeTrailingWildcardKey]
    let userid = request.urlVariables["userid"]

    if audio != nil && userid != nil {
        let filename = String(audio!.dropFirst())
        response.setBody( bytes: [UInt8]( Audio( data: filename, channelId: Global.variable.user[userid!]!.channel, userid: userid! ) ))
            .setHeader(.contentType, value:"audio/aac")
            .completed()
    } else {
        response.completed()
    }
    
}
