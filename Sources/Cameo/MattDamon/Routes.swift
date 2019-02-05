import PerfectHTTP
import PerfectHTTPServer
import Foundation

//key/1
internal func keyOneRoute(request: HTTPRequest, _ response: HTTPResponse) {
    let key = "0Nsco7MAgxowGvkUT8aYag==" //attach to variable
    let data = Data(base64Encoded: key)
    let bytes = [UInt8](data!)
    response.setBody(bytes: bytes)
        .setHeader(.contentType, value:"application/octet-stream")
        .completed()
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
    
    response.setHeader(.contentType, value:"application/json")
    .completed()
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
    
    response.setHeader(.contentType, value:"application/json")
    .completed()
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
    response.setHeader(.contentType, value:"application/json")
    .completed()
}


//playlist
internal func playlistRoute(request: HTTPRequest, _ response: HTTPResponse) {
    let playlistRequest = request.urlVariables[routeTrailingWildcardKey]
    let userid = request.urlVariables["userid"]
    let filename = String(playlistRequest!.dropFirst())
    let channelArray = filename.split(separator: ".")
    let channel = String(channelArray[0])
    
    if channel.count > 0 && userid != nil && playlistRequest != nil {
        
        
        if let ch = Global.variable.user[(userid)!]?.channels[channel]! as? NSDictionary {
            let channelid = ch["channelId"] as? String
            Global.variable.user[userid!]!.channel = channelid!
            
            _ = Session(channelid: channelid!, userid: userid!)
            
            if channelid != nil && userid != nil {
                let playlist = Playlist(channelid: channelid!, userid: userid!)
                response.setBody(string: playlist)
                    .setHeader(.contentType, value:"application/x-mpegURL")
                    .completed()
            } else {
                response.setBody(string: "channel is missing.")
                    .setHeader(.contentType, value:"application/utf8")
                    .completed()
            }
        } else {
            response.setBody(string: "Channel does not exist.")
                .setHeader(.contentType, value:"application/utf8")
                .completed()
        }
    } else {
        response.setBody(string: "Incorrect Parameter.")
        .setHeader(.contentType, value:"application/utf8")
        .completed()
    }
}

internal func audioRoute(request: HTTPRequest, _ response: HTTPResponse) {
    let audio = request.urlVariables[routeTrailingWildcardKey]
    let userid = request.urlVariables["userid"]

    if audio != nil && userid != nil {
        let filename = String(audio!.dropFirst())
        let audio = Audio(data: filename, channelId: Global.variable.user[userid!]!.channel, userid: userid!) as NSData
        let bytes = [UInt8](audio as Data)
        response.setBody(bytes: bytes)
            .setHeader(.contentType, value:"audio/aac")
            .completed()
    } else {
        response.setBody(string: "")
            .setHeader(.contentType, value:"application/text")
            .completed()
        
    }
    
}
