//
//  XtraTune.swift
//  COpenSSL
//
//  Created by Todd on 3/28/19.
//

import Foundation

var keyData = Data()

@available(OSX 10.13, *)
internal func xtraTuneData(channelid: String) -> Data {
    var returnData = Data()

    //  public typealias User = Dictionary<String, LoginData>
    
    typealias itemType = (artist: String, title: String, assetGuid: String, clipImageUrl: String, duration: Double)
    typealias channelType = (channelGuid: String, channelImageUrl: String, channelName: String)
    typealias setType = (channel:channelType,item:[itemType])
    
    var channelDict = Dictionary<String, setType>()
    let endpoint = "https://player.siriusxm.com/rest/v4/aic/tune?channelGuid=c11f049e-c2f8-5299-eae4-ee8841f9ccf3" //Add in data here
    let xtData = GetSync(endpoint: endpoint, method: "XtraTune")    //MARK - for Sync
    let successMsg = xtData.value( forKeyPath: "ModuleListResponse.messages" ) as? NSArray
    let messageDict = successMsg?.firstObject as? NSDictionary
    let message = messageDict?.value( forKeyPath: "message" ) as? String
    let code = messageDict?.value( forKeyPath: "code" ) as? Int
    
    if ( code == 100 || message == "successful" ) {
        if let moduleList = xtData.value( forKeyPath: "ModuleListResponse.moduleList.modules" ) as? NSArray {
            let mods = moduleList.firstObject as? NSDictionary
            
            let chinfo = mods!.value( forKeyPath: "moduleResponse.additionalChannelData.channel" ) as? NSDictionary
            let channelGuid = chinfo!.value( forKeyPath: "channelGuid" ) as! String
            let channelImageUrl = chinfo!.value( forKeyPath: "channelImageUrl" ) as! String
            let channelName = chinfo!.value( forKeyPath: "name" ) as! String

            let channelinfo = (channelGuid: channelGuid, channelImageUrl: channelImageUrl, channelName: channelName) as channelType
       
            if let clipList = mods!.value( forKeyPath: "moduleResponse.additionalChannelData.clipList.clips" ) as? NSArray {
                var itemArray = Array<itemType>()
                
                
                for i in clipList  {
                    if let item = i as? NSDictionary {
                        let artist = item.value( forKeyPath: "artistName" ) as! String
                        let title = item.value( forKeyPath: "title" ) as! String
                        let assetGuid = item.value( forKeyPath: "assetGuid" ) as! String
                        let clipImageUrl = item.value( forKeyPath: "clipImageUrl" ) as! String
                        //let consumptionInfo = item.value( forKeyPath: "consumptionInfo" ) as! String
                        let duration = item.value( forKeyPath: "duration" ) as! Double
                        
                        let item = (artist:artist, title: title, assetGuid: assetGuid, clipImageUrl:clipImageUrl, duration: duration) as itemType
                        itemArray.append(item)
                    }
                }
                
                channelDict[channelName] = (channel:channelinfo,item:itemArray)

            }
        
         }
        
        
        print(channelDict)
        returnData = try! NSKeyedArchiver.archivedData(withRootObject: channelDict, requiringSecureCoding: false)

        
       // pl = xtraPlaylist(item: item1!, assetGuid: assetGuid!)
        
    }
    
    return returnData
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
