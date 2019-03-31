//
//  XtraAudio.swift
//  Cameo
//
//  Created by Todd on 3/30/19.
//

import Foundation

func xtraAudio(data: String) -> Data {
    
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
        prefix = "https://priprodtracks.mountain.siriusxm.com"
    } else {
        prefix = "https://priprodtracks.mountain.siriusxm.com"
    }
    
    
    //let suffix = Global.variable.user[userid]!.consumer  + "&token=" + Global.variable.user[userid]!.token
    let endpoint = prefix! + data 
    let audio = DataSync(endpoint: endpoint, method: "AAC")
    
    //prefix = nil
    return audio
}
