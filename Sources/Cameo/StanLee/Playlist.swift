
//
//  Playlist makek
//
//  Created by Todd on 1/16/19.
//

import Foundation

//Cached verison of Playlist
func Playlist(channelId: String ) -> String {
    
    let bitrate = "256k" //this may be an optin in the future
    let size = "small"
    let underscore = "_"
    let version = "v3"
    let ext = ".m3u8"
    
    let tail = channelId + underscore + bitrate + underscore + size + underscore + version + ext
    var source : String? = Global.variable.user[Global.variable.userid]!.keyurl
    
    let usePrime = true
    
    if usePrime {
        source = source!.replacingOccurrences(of: "%Live_Primary_HLS%", with: Global.variable.hls_sources["Live_Primary_HLS"]!)
    } else {
        source = source!.replacingOccurrences(of: "%Live_Primary_HLS%", with: Global.variable.hls_sources["Live_Secondary_HLS"]!)
    }
    
    source = source!.replacingOccurrences(of: "32k", with: bitrate)
    
    
    ///currently using a originating key/1 URL as a base
    ///reduces having to call the Variant
    ///we may start including the Variant call as part of the config in the future
    source = source!.replacingOccurrences(of: "key/1", with: tail)
    
    source = source! + Global.variable.user[Global.variable.userid]!.consumer + "&token=" + Global.variable.user[Global.variable.userid]!.token
    var playlist : String? = TextSync(endpoint: source!, method: "variant")
    
    if playlist != nil {
        playlist = playlist!.replacingOccurrences(of: "key/1", with: "http://" + Global.variable.ipaddress + ":" + String(Global.variable.port) + "/key/1")
        playlist = playlist!.replacingOccurrences(of: channelId, with: "/audio/" + channelId)
        
        source?.removeAll()
        return playlist!
    }
    
    source?.removeAll()
    return ""

}
