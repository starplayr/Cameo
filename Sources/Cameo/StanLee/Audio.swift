//PlayList
import Foundation

func Audio(data: String, channelId: String, userid: String) -> Data {
    
    let prefix = Global.variable.hls_sources["Live_Primary_HLS"]! + "/AAC_Data/" + channelId + "/HLS_" + channelId + "_256k_v3/"
    let suffix = Global.variable.user[userid]!.consumer  + "&token=" + Global.variable.user[userid]!.token
    let endpoint = prefix + data + suffix
    let audio = DataSync(endpoint: endpoint, method: "AAC")

    return audio
}
