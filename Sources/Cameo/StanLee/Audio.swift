//PlayList
import Foundation

func Audio(data: String, channelId: String, userid: String) -> Data {
    
    var prefix : String? = ""
    
    var bitrate = "64k"
    
    //Get Network Info, so we know what to do with the stream
    
    /* This is for iOS only should put it in its own file
    let network = Reachability.getNetworkType()
    
    Global.variable.connectionType = (network.trackingId)
    Global.variable.connectionInt = (network.networkTypeInt)
    
    
    if ( Global.variable.connectionInt == 1 || Global.variable.connectionInt == 5 ) {
        bitrate = "256k"
    } else if ( Global.variable.connectionInt == 3 || Global.variable.connectionInt == 4 ) {
        bitrate = "64k"
    } else {
        bitrate = "32k"
    }
    */
    
    if Global.variable.usePrime {
        prefix = Global.variable.hls_sources["Live_Primary_HLS"]! + "/AAC_Data/" + channelId + "/HLS_" + channelId + "_" + bitrate + "_v3/"
    } else {
        prefix = Global.variable.hls_sources["Live_Secondary_HLS"]! + "/AAC_Data/" + channelId + "/HLS_" + channelId + "_" + bitrate + "_v3/"
    }
    
    
    let suffix = Global.variable.user[userid]!.consumer  + "&token=" + Global.variable.user[userid]!.token
    let endpoint = prefix! + data + suffix
    let audio = DataSync(endpoint: endpoint, method: "AAC")

    prefix = nil
    return audio
}
