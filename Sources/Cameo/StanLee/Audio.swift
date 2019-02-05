//PlayList
import Foundation

func Audio(data: String, channelId: String, userid: String) -> Data {
    
    var prefix : String? = ""
    
    if Global.variable.usePrime {
        prefix = Global.variable.hls_sources["Live_Primary_HLS"]! + "/AAC_Data/" + channelId + "/HLS_" + channelId + "_256k_v3/"
    } else {
        prefix = Global.variable.hls_sources["Live_Secondary_HLS"]! + "/AAC_Data/" + channelId + "/HLS_" + channelId + "_256k_v3/"
    }
    
    
    let suffix = Global.variable.user[userid]!.consumer  + "&token=" + Global.variable.user[userid]!.token
    let endpoint = prefix! + data + suffix
    let audio = DataSync(endpoint: endpoint, method: "AAC")

    prefix = nil
    return audio
}
