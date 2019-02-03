
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
    var source : String? = gUser[gLoggedinUser]!.keyurl
    
    if usePrime {
        source = source!.replacingOccurrences(of: "%Live_Primary_HLS%", with: hls_sources["Live_Primary_HLS"]!)
    } else {
        source = source!.replacingOccurrences(of: "%Live_Primary_HLS%", with: hls_sources["Live_Secondary_HLS"]!)
    }
    
    source = source!.replacingOccurrences(of: "32k", with: bitrate)
    
    
    ///currently using a originating key/1 URL as a base
    ///reduces having to call the Variant
    ///we may start including the Variant call as part of the config in the future
    source = source!.replacingOccurrences(of: "key/1", with: tail)
    
    source = source! + gUser[gLoggedinUser]!.consumer + "&token=" + gUser[gLoggedinUser]!.token
    var playlist : String? = TextSync(endpoint: source!, method: "variant")
    
    if playlist != nil {
        
        playlist = playlist!.replacingOccurrences(of: "key/1", with: "http://localhost:1111/key/1")
        playlist = playlist!.replacingOccurrences(of: channelId, with: "/audio/" + channelId)
        
        source?.removeAll()
        return playlist!
    }
    
    source?.removeAll()
    return ""

}
