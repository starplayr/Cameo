//PlayList
import Foundation

func Audio(data: String, channelId: String) -> Data {
    
    let prefix = Global.variable.hls_sources["Live_Primary_HLS"]! + "/AAC_Data/" + channelId + "/HLS_" + channelId + "_256k_v3/"
    let suffix = Global.variable.user[Global.variable.userid]!.consumer  + "&token=" + Global.variable.user[Global.variable.userid]!.token
    
    //playlist = playlist!.replacingOccurrences(of: channelId, with: prefix + channelId)
    //playlist = playlist!.replacingOccurrences(of: ".aac", with: ".aac" + suffix)
    
    let endpoint = prefix + data + suffix
    let audio = DataSync(endpoint: endpoint, method: "AAC")

    return audio
}
