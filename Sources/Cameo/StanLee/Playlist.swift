
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
        

        // let prefix = hls_sources["Live_Primary_HLS"]! + "/AAC_Data/" + channelId + "/HLS_" + channelId + "_256k_v3/"
        //let suffix = gUser[gLoggedinUser]!.consumer  + "&token=" + gUser[gLoggedinUser]!.token
        
       // let endpoint = prefix + data + suffix
        playlist = playlist!.replacingOccurrences(of: "key/1", with: "http://localhost:1111/key/1")
        playlist = playlist!.replacingOccurrences(of: channelId, with: "/audio/" + channelId)
        
        source?.removeAll()
        return playlist!
    }
    
    source?.removeAll()
    return ""

}



//https://siriusxm-priprodlive.akamaized.net/AAC_Data/siriushits1/HLS_siriushits1_256k_v3/siriushits1_256k_1_020257686552_03523053_v3.aac?consumer=k2&gupId=D903EFA651C741B3356C26BE514AC017&token=1549123528_838c0fe1604f71b93d9ad6dc4b024584
//https://siriusxm-priprodlive.akamaized.net/AAC_Data/siriushits1/HLS_siriushits1_256k_v3/siriushits1_256k_1_020258096152_03523095_v3.aac?token=1549125113_c9a2ac21178822a43fe65dd17c36261f&consumer=k2&gupId=D903EFA651C741B3356C26BE514AC017
