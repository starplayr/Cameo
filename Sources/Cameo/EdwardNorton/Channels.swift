import Foundation

typealias ChannelsTuple = (success: Bool, message: String, data: Dictionary<String, Any>)

internal func Channels(channelType: String) -> ChannelsTuple {
    var success : Bool? = false
    var message : String? = "Something's not right."
    
    let endpoint = Global.variable.http + Global.variable.root + "/get"
    let method = "channels"
    let request =  ["moduleList": ["modules": [["moduleArea": "Discovery", "moduleType": "ChannelListing", "moduleRequest": ["consumeRequests": [], "resultTemplate": "responsive", "alerts": [], "profileInfos": []]]]]] as Dictionary
    
    let result = PostSync(request: request, endpoint: endpoint, method: method )
    
    if (result.response.statusCode) == 403 {
        success = false
        message = "Too many incorrect logins, Sirius XM has blocked your IP for 24 hours."
    }
    
    if result.success {
        let result = result.data as NSDictionary
        let r = result.value(forKeyPath: "ModuleListResponse.moduleList.modules")
        
        if r != nil {
            let m = r as? NSArray
            let o = m![0] as! NSDictionary
            let d = o.value( forKeyPath: "moduleResponse.contentData.channelListing.channels") as! NSArray
            
            var ChannelDict : Dictionary? = Dictionary<String, Any>()
            
            for i in d {
                let dict = i as! NSDictionary
                let channelGuid = dict.value( forKeyPath: "channelGuid")! as! String
                let channelId = dict.value( forKeyPath: "channelId")! as! String
                let channelNumber = dict.value( forKeyPath: "channelNumber")! as! String
                let images = dict.value( forKeyPath: "images.images")! as! NSArray
                let streamingName = dict.value( forKeyPath: "streamingName")! as! String
                let name = dict.value( forKeyPath: "name")! as! String
                
                var mediumImage = "" as String
                var smallImage = ""
                var tinyImage = ""
                for img in images {
                    let g = img as! NSDictionary
                    
                    let height = g["height"]! as! Int
                    let width = g["height"]! as! Int
                    
                    if height == 720 {
                        mediumImage = g["url"] as! String
                    } else if height == 360 {
                        smallImage = g["url"] as! String
                    } else if height == 80 && width == 80  {
                        tinyImage = g["url"] as! String
                    }
                }
                
                let cl = [ "channelId": channelId, "channelNumber": channelNumber, "streamingName": streamingName, "name": name, "mediumImage": mediumImage, "smallImage": smallImage, "tinyImage": tinyImage, "channelGuid": channelGuid ]
                if channelType == "id" {
                    ChannelDict![channelId] = cl
                } else if channelType == "name" {
                    ChannelDict![name] = cl
                } else if channelType == "number" {
                    ChannelDict![channelNumber] = cl
                } else {
                    ChannelDict![channelId] = cl
                }
            }
            
            Global.variable.channels = ChannelDict!
            
            if Global.variable.channels.count > 1 {
                success = true
                message = "Read the channels in."
                return (success: success!, message: message!, data: ChannelDict!)
            }
        } else {
            success = false
            message = "Error, receiving channels. You are probably not logged in."
        }
        
    }
    
    return (success: success!, message: message!, data: result.data)

}
