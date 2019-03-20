
//
//  Playlist makek
//
//  Created by Todd on 1/16/19.
//

import Foundation

//Cached verison of Playlist
func Playlist(channelid: String, userid: String ) -> String {
    
    var bitrate = "64k"
    var cache = 18
    //Get Network Info, so we know what to do with the stream
    
    /* This is for iOS only should put it in its own file
    let network = Reachability.getNetworkType()
    
    Global.variable.connectionType = (network.trackingId)
    Global.variable.connectionInt = (network.networkTypeInt)
    
    if ( Global.variable.connectionInt == 1 || Global.variable.connectionInt == 5 ) {
        bitrate = "256k"
        cache = 18
    } else if ( Global.variable.connectionInt == 3 || Global.variable.connectionInt == 4 ) {
        bitrate = "64k"
        cache = 15
    } else {
        bitrate = "32k"
        cache = 12
    }
    */
    
    
    let size = "small"
    let underscore = "_"
    let version = "v3"
    let ext = ".m3u8"
    
    let tail = channelid + underscore + bitrate + underscore + size + underscore + version + ext
    var source : String? = Global.variable.user[userid]!.keyurl
    
    if Global.variable.usePrime {
        source = source!.replacingOccurrences(of: "%Live_Primary_HLS%", with: Global.variable.hls_sources["Live_Primary_HLS"]!)
    } else {
        source = source!.replacingOccurrences(of: "%Live_Primary_HLS%", with: Global.variable.hls_sources["Live_Secondary_HLS"]!)
    }
    
    source = source!.replacingOccurrences(of: "32k", with: bitrate)
    
    
    ///currently using a originating key/1 URL as a base
    ///reduces having to call the Variant
    ///we may start including the Variant call as part of the config in the future
    source = source!.replacingOccurrences(of: "key/1", with: tail)
    
    source = source! + Global.variable.user[userid]!.consumer + "&token=" + Global.variable.user[userid]!.token
    var playlist : String? = TextSync(endpoint: source!, method: "variant")
    
    if playlist != nil {
        
        //fix key path
        playlist = playlist!.replacingOccurrences(of: "key/1", with: "/key/1/" + userid)
        
        //add audio and userid prefix (used for internal multi user or multi service setup)
        playlist = playlist!.replacingOccurrences(of: channelid, with: "/audio/" + userid + "/" + channelid)
        
        //is insync with PDT
        playlist = playlist!.replacingOccurrences(of: "#EXTINF:10,", with: "#EXTINF:1," + userid)

        
        source = nil
        
      
        let newString = playlist!.replacingOccurrences(of: "\r", with: "")
        let newArray  = newString.components(separatedBy: "\n") as Array
        
        
        var newplaylist = ""
        
        for i in 0...(newArray.count - 1) {
            newplaylist = newplaylist + newArray[i] + "\r\n"
           if i == cache {
                break
           }
        }
       
        //print(newplaylist)
        //print(newplaylist)
        return newplaylist
    }
    
    source = nil
    return ""

}
