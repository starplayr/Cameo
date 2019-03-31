//
//  XtraTune.swift
//  COpenSSL
//
//  Created by Todd on 3/28/19.
//

import Foundation

var keyData = Data()

internal func xtraTune(channelid: String, userid: String) -> String {
    var returnData2 = ""
    //resume
    let endpoint = "https://player.siriusxm.com/rest/v4/aic/tune?channelGuid=86d52e32-09bf-a02d-1b6b-077e0aa05200"
    
    let returnData = GetSync(endpoint: endpoint, method: "XtraTune")    //MARK - for Sync
    
    let successMsg = returnData.value( forKeyPath: "ModuleListResponse.messages" ) as? NSArray
    
    let messageDict = successMsg?.firstObject as? NSDictionary

    let message = messageDict?.value( forKeyPath: "message" ) as? String
    let code = messageDict?.value( forKeyPath: "code" ) as? Int
    
    if ( code == 100 || message == "successful" ) {
        let moduleList = returnData.value( forKeyPath: "ModuleListResponse.moduleList.modules" ) as? NSArray
        
        print(moduleList)
        let mods = moduleList?.firstObject as? NSDictionary
        let channelinfo = mods!.value( forKeyPath: "moduleResponse.additionalChannelData.channel" ) as? NSDictionary
        
        let channelGuid = channelinfo?.value( forKeyPath: "channelGuid" ) as? String
        print("channelGuid",channelGuid)
        let channelImageUrl = channelinfo?.value( forKeyPath: "channelImageUrl" ) as? String
        let channelLastUpdated = channelinfo?.value( forKeyPath: "channelLastUpdated" ) as? String
        let name = channelinfo?.value( forKeyPath: "name" ) as? String

        
        print(channelGuid,channelImageUrl,channelLastUpdated,name)
        //Optional("%AIC_Image%/images/chan/c0/84560d-f0d1-21e0-4953-4f19380c82a3.png")
        //Optional("%AIC_Image%/images/chan/c0/84560d-f0d1-21e0-4953-4f19380c82a3.png")
        //Optional("2019-02-22T15:52:57.671Z")
        //Optional("Hits 1 Discovery")
        
       // print(moduleList)
        
        let clipList = mods!.value( forKeyPath: "moduleResponse.additionalChannelData.clipList.clips" ) as? NSArray
        let item1 = clipList?.firstObject as? NSDictionary
    
        let artistName = item1?.value( forKeyPath: "artistName" ) as? String
        let title = item1?.value( forKeyPath: "title" ) as? String
        
        let assetGuid = item1?.value( forKeyPath: "assetGuid" ) as? String
        print("assetGuid",assetGuid)

        let clipImageUrl = item1?.value( forKeyPath: "clipImageUrl" ) as? String
        let consumptionInfo = item1?.value( forKeyPath: "consumptionInfo" ) as? String
        let duration = item1?.value( forKeyPath: "duration" ) as? Double


        
        let contentUrls = item1?.value( forKeyPath: "contentUrlList.contentUrls" ) as? NSArray
        let url1 = contentUrls?.firstObject as? NSDictionary
        var streamUrl = url1?.value( forKeyPath: "url" ) as? String
        
        let AIC_Primary_HLS = "https://priprodtracks.mountain.siriusxm.com"
        let bitrate = "64k"
        
        var variant = streamUrl!.replacingOccurrences(of: "%AIC_Primary_HLS%" , with: "https://priprodtracks.mountain.siriusxm.com")
        
        var variant2 = TextSync(endpoint: variant, method: "xtra")
        print(variant2)
        
        var keyUrl = streamUrl!.replacingOccurrences(of: "%AIC_Primary_HLS%" , with: "https://player.siriusxm.com/rest/streaming")
        keyUrl = keyUrl.replacingOccurrences(of: "variant_small_v3.m3u8" , with: "64k_v3/key/4")
        
        keyData = DataSync(endpoint: keyUrl, method: "key")
        
        print(keyData)
        var baseStreamUrl = streamUrl!.replacingOccurrences(of: "%AIC_Primary_HLS%" , with: "/xtraAudio")

        baseStreamUrl = baseStreamUrl.replacingOccurrences(of: "_variant_small_v3.m3u8" , with: "_64k_v3/")

        streamUrl = streamUrl!.replacingOccurrences(of: "%AIC_Primary_HLS%", with: AIC_Primary_HLS)
        let playListURL = streamUrl!.replacingOccurrences(of: "variant_small" , with: bitrate + "_v3/" + assetGuid! + "_64k_small")
        
        
        
        
       // print(baseStreamUrl)
        
        
        returnData2 = TextSync(endpoint: playListURL, method: "xtra")
        
        returnData2 = returnData2.replacingOccurrences(of: "key/4", with: "/key/4")
        
        returnData2 = returnData2.replacingOccurrences(of: assetGuid!, with: baseStreamUrl + assetGuid!)

      //  print(returnData2)
        //https://player.siriusxm.com/rest/streaming/clips/siriushits1/3b5de111-3291-8328-66a3-99578dcfda32/ab779013bc142bad6ab963a5d3a5d6e700/audio/3b5de111-3291-8328-66a3-99578dcfda32_64k_v3/key/4
        //https://player.siriusxm.com/rest/streaming/clips/siriushits1/07525fa7-edf9-3e93-5d25-a8d293f0b0a5/3e0283a9894e077abbb5b921c2dd80ca/audio/07525fa7-edf9-3e93-5d25-a8d293f0b0a5_64k_v3/key/4
        //print(returnData2)
        //print(streamUrl)
        //https://player.siriusxm.com/rest/streaming/clips/siriushits1 /f23a2763-48df-33a2-ced6-4e2d180e3f0a/3986c1ce7c35d023a5ccb52be06c9552/audio/f23a2763-48df-33a2-ced6-4e2d180e3f0a_32k_v3/key/4
        //https://priprodtracks.mountain.siriusxm.com/clips/siriushits1/235da263-ec09-98b5-d4c9-0293d663b957/ee9b5e3ca625a6ca35a65152a03b6ca6/audio/235da263-ec09-98b5-d4c9-0293d663b957_64k/235da263-ec09-98b5-d4c9-0293d663b957_v3.m3u8
        //https://priprodtracks.mountain.siriusxm.com/clips/siriushits1/3b5de111-3291-8328-66a3-99578dcfda32/ab779013bc142bad6ab963a5d3a5d6e7/audio/3b5de111-3291-8328-66a3-99578dcfda32_64k_v3/3b5de111-3291-8328-66a3-99578dcfda32_64k_small_v3.m3u8
        //https://priprodtracks.mountain.siriusxm.com/clips/siriushits1/8634da97-cb63-2edf-bff1-c2884ec944d0/13f646e1bfb4d64c0312bb155c25a6de/audio/8634da97-cb63-2edf-bff1-c2884ec944d0_64k_v3/8634da97-cb63-2edf-bff1-c2884ec944d0_64k_small_v3.m3u8
        
        //https://priprodtracks.mountain.siriusxm.com/clips/siriushits1/8634da97-cb63-2edf-bff1-c2884ec944d0/13f646e1bfb4d64c0312bb155c25a6de/audio/
        
        //https://priprodtracks.mountain.siriusxm.com/clips/siriushits1/476a3d6b-a426-97ed-3f4c-ea9656c7fab5/909f01e29dee07d9dfdd9d7425849b12/audio/476a3d6b-a426-97ed-3f4c-ea9656c7fab5_64k_v3/
        //https://priprodtracks.mountain.siriusxm.com/clips/siriushits1/8634da97-cb63-2edf-bff1-c2884ec944d0/13f646e1bfb4d64c0312bb155c25a6de/audio/8634da97-cb63-2edf-bff1-c2884ec944d0_64k_v3/f23a2763-48df-33a2-ced6-4e2d180e3f0a_64k_4_022775462134_00000000_v3.aac
        //https://priprodtracks.mountain.siriusxm.com/clips/siriushits1/4d5482e9-28c7-5f40-bf8f-40cf167d3592/4d89dab0dffc62d51edecffd08313ea4/audio/4d5482e9-28c7-5f40-bf8f-40cf167d3592
        //https://priprodtracks.mountain.siriusxm.com/clips/siriushits1/fd85d327-5d3b-b76f-c1aa-17ad4539d769/ab677b35505a907bfc87a1ac33a3940de2/audio/fd85d327-5d3b-b76f-c1aa-17ad4539d769_64k_v3/fd85d327-5d3b-b76f-c1aa-17ad4539d769_64k_4_031381683613_00000017_v3.aac
        //https://priprodtracks.mountain.siriusxm.com/clips/siriushits1/dd6b2376-5292-6996-8bc3-152f220885cd/8b758188aced8ad4a340f30b75ba6416/audio/dd6b2376-5292-6996-8bc3-152f220885cd_64k_v3/dd6b2376-5292-6996-8bc3-152f220885cd_64k_4_021177968857_00000000_v3.aac
        //https://priprodtracks.mountain.siriusxm.com/clips/siriushits1/b9c2363d-271a-411e-09c6-016339f81791/258dcdd6906a8dfb272da3aabaefb6b3/audio/b9c2363d-271a-411e-09c6-016339f81791_32k_v3/b9c2363d-271a-411e-09c6-016339f81791_32k_4_030605139956_00000000_v3.aac
                                // /clips/siriushits1/1dd1714c-05de-0b36-42f9-48a52b173d1a/eef42b585105e5977c5879be743f49fe/audio/1dd1714c-05de-0b36-42f9-48a52b173d1a_64k_v3/1dd1714c-05de-0b36-42f9-48a52b173d1a_64k_4_111586048196_00000024_v3.aac
        
        
        
    }
   
    return returnData2

}


/*
 [INFO] Starting HTTP server  on 127.0.0.1:9999
 {
 ModuleListResponse =     {
 messages =         (
 {
 code = 100;
 message = Successful;
 }
 );
 moduleList =         {
 modules =             (
 {
 moduleArea = Discover;
 moduleRespon
 
 */
