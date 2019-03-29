//
//  XtraTune.swift
//  COpenSSL
//
//  Created by Todd on 3/28/19.
//

import Foundation


internal func xtraTune(channelid: String, userid: String) -> String {
    
    //resume
    let endpoint = "https://player.siriusxm.com/rest/v4/aic/tune?channelGuid=86d52e32-09bf-a02d-1b6b-077e0aa05200"
    
    let returnData = GetSync(endpoint: endpoint, method: "XtraTune")    //MARK - for Sync
    
    let successMsg = returnData.value( forKeyPath: "ModuleListResponse.messages" ) as? NSArray
    
    let messageDict = successMsg?.firstObject as? NSDictionary

    let message = messageDict?.value( forKeyPath: "message" ) as? String
    let code = messageDict?.value( forKeyPath: "code" ) as? Int
    
    if ( code == 100 || message == "successful" ) {
        let moduleList = returnData.value( forKeyPath: "ModuleListResponse.moduleList.modules" ) as? NSArray
        let mods = moduleList?.firstObject as? NSDictionary
        let channelinfo = mods!.value( forKeyPath: "moduleResponse.additionalChannelData.channel" ) as? NSDictionary
        
        let channelGuid = channelinfo?.value( forKeyPath: "channelImageUrl" ) as? String
        let channelImageUrl = channelinfo?.value( forKeyPath: "channelImageUrl" ) as? String
        let channelLastUpdated = channelinfo?.value( forKeyPath: "channelLastUpdated" ) as? String
        let name = channelinfo?.value( forKeyPath: "name" ) as? String

        
        print(channelGuid,channelImageUrl,channelLastUpdated,name)


    }
    return("FooBar")
    
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
