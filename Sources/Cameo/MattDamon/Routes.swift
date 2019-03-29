import PerfectHTTP
import PerfectHTTPServer
import Foundation


//Encryption Key for main streams Sirius XM
internal func keyOneRoute(request: HTTPRequest, _ response: HTTPResponse) {
    var key : String? = "" //default to empty string
    let userid = request.urlVariables["userid"]
    
    if  userid != nil && Global.variable.user[userid!]!.key.count > 1 {
        key = Global.variable.user[userid!]!.key
    }
    
    response.setBody(bytes: [UInt8](Data(base64Encoded: key!)!)).setHeader(.contentType, value:"application/octet-stream").completed()
    key = nil
}

//Encpytion Key for Xtra Channels Sirius XM
internal func keyFourRoute(request: HTTPRequest, _ response: HTTPResponse) {
    let key = [177, 245, 101, 84, 49, 183, 21, 122, 115, 13, 24, 211, 89, 255, 106, 209] as [UInt8]
    let userid = request.urlVariables["userid"]
    
    if userid != nil {
        response.setBody(bytes: [UInt8](key)).setHeader(.contentType, value:"application/octet-stream").completed()
    }
    
}

internal func PDTRoute(request: HTTPRequest, _ response: HTTPResponse) {
    let userid = request.urlVariables["userid"]  
    let artistSongData = PDT(userid:userid!)
    let jayson = ["data": artistSongData, "message": "0000", "success": true] as [String : Any]
    try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
}

//login
internal func loginRoute(request: HTTPRequest, _ response: HTTPResponse)  {
    
    var returnData : (success: Bool, message: String, data: String) = (success: false, message: "", data: "")
    
    if let body = request.postBodyString {
        
        do {
            let json = try body.jsonDecode() as? [String:Any]
            let user = json?["user"] as? String ?? ""
            let pass = json?["pass"] as? String ?? ""
            
            if user != "" || pass != "" {
                //Login func
                returnData = Login(user: user, pass: pass)
                
                let jayson = ["data": returnData.data, "message": returnData.message, "success": returnData.success] as [String : Any]
                try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
            } else {
                let jayson = ["data": "", "message": "Missing username or password / 'user' or 'pass' key.", "success": false] as [String : Any]
                try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
            }
            
        } catch {
            let jayson = ["data": "", "message": "Syntax Error or invalid JSON", "success": false] as [String : Any]
            try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
        }
        
    } else {
        let jayson = ["data": "", "message": returnData.message, "success": false] as [String : Any]
        try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
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
                try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
            } else {
                let jayson = ["data": "", "message": "Missing channelid, userid or key.", "success": false] as [String : Any]
                try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
            }
        } catch {
            let jayson = ["data": "", "message": "Syntax Error or invalid JSON.", "success": false] as [String : Any]
            try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
        }
        
    } else {
        let jayson = ["data": "", "message": "Session may be invalid, try logging in first.", "success": false] as [String : Any]
        try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
    }
}

//xtra session
internal func xtraSessionRoute(request: HTTPRequest, _ response: HTTPResponse) {
    
    if let body = request.postBodyString {
        
        do {
            let json = try body.jsonDecode() as? [String:Any]
            let channelid = json?["channelid"] as? String ?? ""
            let userid = json?["userid"] as? String ?? ""
            
            if channelid != "" && userid != "" {
                //Session func
                let returnData = XtraSession(channelid: channelid, userid: userid)
                let jayson = ["data": returnData, "message": "coolbeans", "success": true] as [String : Any]
                try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
            } else {
                let jayson = ["data": "", "message": "Missing channelid, userid or key.", "success": false] as [String : Any]
                try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
            }
        } catch {
            let jayson = ["data": "", "message": "Syntax Error or invalid JSON.", "success": false] as [String : Any]
            try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
        }
        
    } else {
        let jayson = ["data": "", "message": "Session may be invalid, try logging in first.", "success": false] as [String : Any]
        try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
    }
}

internal func xtraTuneRoute(request: HTTPRequest, _ response: HTTPResponse) {
    
    if let body = request.postBodyString {
        
        do {
            let json = try body.jsonDecode() as? [String:Any]
            let channelid = json?["channelid"] as? String ?? ""
            let userid = json?["userid"] as? String ?? ""
            
            if channelid != "" && userid != "" {
                //Session func
                let returnData = xtraTune(channelid: channelid, userid: userid)
                let jayson = ["data": returnData, "message": "coolbeans", "success": true] as [String : Any]
                try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
            } else {
                let jayson = ["data": "", "message": "Missing channelid, userid or key.", "success": false] as [String : Any]
                try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
            }
        } catch {
            let jayson = ["data": "", "message": "Syntax Error or invalid JSON.", "success": false] as [String : Any]
            try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
        }
        
    } else {
        let jayson = ["data": "", "message": "Session may be invalid, try logging in first.", "success": false] as [String : Any]
        try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
    }
}

internal func autoLoginRoute(request: HTTPRequest, _ response: HTTPResponse)  {
    
    var returnData : (success: Bool, message: String, data: String) = (success: false, message: "", data: "")
    
    if let body = request.postBodyString {
        
        do {
            let json = try body.jsonDecode() as? [String:Any]
            let user = json?["user"] as? String ?? ""
            let pass = json?["pass"] as? String ?? ""
            
            if user != "" || pass != "" {
                //Login func
                returnData = Login(user: user, pass: pass)
                
                if returnData.success {
                    let sessionData = Session(channelid: "siriushits1", userid: returnData.data)
                    print(sessionData)
                    let channelData = Channels(channeltype: "numbers", userid: returnData.data)
                    print(channelData.success)
                }
         
                let jayson = ["data": returnData.data, "message": returnData.message, "success": returnData.success] as [String : Any]
                try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
            } else {
                let jayson = ["data": "", "message": "Missing username or password / 'user' or 'pass' key.", "success": false] as [String : Any]
                try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
            }
            
        } catch {
            let jayson = ["data": "", "message": "Syntax Error or invalid JSON", "success": false] as [String : Any]
            try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
        }
        
    } else {
        let jayson = ["data": "", "message": returnData.message, "success": false] as [String : Any]
        try? _ = response.setBody(json: jayson).setHeader(.contentType, value:"application/json").completed()
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
    
    if channel != ""  && userid != nil && playlistRequest != nil && Global.variable.user[userid!]!.channels.count > 1 {
        let ch = Global.variable.user[userid!]!.channels[channel!] as? NSDictionary
        
        if ch != nil {
            let channelid = ch!["channelId"] as? String
            Global.variable.user[userid!]!.channel = channelid!
        
            if channelid != nil && userid != nil {
                _ = Session(channelid: channelid!, userid: userid!)
                let playlist = Playlist(channelid: channelid!, userid: userid!)
                response.setBody(string: playlist).setHeader(.contentType, value:"application/x-mpegURL").completed()

                //then trail for remaining to speed up time
                if Global.variable.streaming {
                  // _ = Session(channelid: channelid!, userid: userid!)
                }
                
            } else {
                response.setBody(string: "Channel is missing.\n\r").setHeader(.contentType, value:"text/plain").completed()
            }
            
           
        } else {
            response.setBody(string: "The channel does not exist.\n\r").setHeader(.contentType, value:"text/plain").completed()
        }
    } else {
        response.setBody(string: "Incorrect Parameter.\n\r").setHeader(.contentType, value:"text/plain").completed()
    }
}

//ping
internal func pingRoute(request: HTTPRequest, _ response: HTTPResponse) {
    response.setBody(string: "pong").setHeader(.contentType, value:"text/plain").completed()
}


internal func audioRoute(request: HTTPRequest, _ response: HTTPResponse) {
    let audio = request.urlVariables[routeTrailingWildcardKey]
    let userid = request.urlVariables["userid"]

    if audio != nil && userid != nil {
        let filename = String(audio!.dropFirst())
        response.setBody( bytes: [UInt8]( Audio( data: filename, channelId: Global.variable.user[userid!]!.channel, userid: userid! ) )).setHeader(.contentType, value:"audio/aac")
            .completed()
    } else {
        response.completed()
    }
    
}



