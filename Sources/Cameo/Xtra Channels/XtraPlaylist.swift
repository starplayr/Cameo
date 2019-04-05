//
//  XtraPlaylist.swift
//  Cameo
//
//  Created by Todd on 3/31/19.
//

import Foundation


func xtraPlaylist( item: NSDictionary, assetGuid: String ) -> String {

    var playList = ""
    
    let contentUrls = item.value( forKeyPath: "contentUrlList.contentUrls" ) as? NSArray
    let url1 = contentUrls?.firstObject as? NSDictionary
    var streamUrl = url1?.value( forKeyPath: "url" ) as? String
    
    let AIC_Primary_HLS = "https://priprodtracks.mountain.siriusxm.com"
    let bitrate = "256k" // choices are 256k, 96k, 64k, 32k
    
    //We predict the variant, so we don't have to do this
    //var variant = streamUrl!.replacingOccurrences(of: "%AIC_Primary_HLS%" , with: "https://priprodtracks.mountain.siriusxm.com")
    // var variant2 = TextSync(endpoint: variant, method: "xtra")
    // print(variant2)
    
    var keyUrl = streamUrl!.replacingOccurrences(of: "%AIC_Primary_HLS%" , with: "https://player.siriusxm.com/rest/streaming")
    keyUrl = keyUrl.replacingOccurrences(of: "variant_small_v3.m3u8" , with: bitrate + "_v3/key/4")
    
    keyData = DataSync(endpoint: keyUrl, method: "key")
    
    var baseStreamUrl = streamUrl!.replacingOccurrences(of: "%AIC_Primary_HLS%" , with: "/xtraAudio")
    
    baseStreamUrl = baseStreamUrl.replacingOccurrences(of: "_variant_small_v3.m3u8" , with: "_" + bitrate + "_v3/")
    
    streamUrl = streamUrl!.replacingOccurrences(of: "%AIC_Primary_HLS%", with: AIC_Primary_HLS)
    let playListURL = streamUrl!.replacingOccurrences(of: "variant_small" , with: bitrate + "_v3/" + assetGuid + "_" + bitrate + "_small")
    
    
    playList = TextSync(endpoint: playListURL, method: "xtra")
    playList = playList.replacingOccurrences(of: "key/4", with: "/key/4")
    playList = playList.replacingOccurrences(of: assetGuid, with: baseStreamUrl + assetGuid)
    
    return playList
    
}
