//
//  PDT.swift
//  Camouflage
//
//  Created by Todd on 1/27/19.
//

import Foundation

//URL: https://player.siriusxm.com/rest/v2/experience/modules/get/discover-channel-list?type=2&batch-mode=true&format=json&request-option=discover-channel-list-withpdt&result-template=web&time=1548615083793

func PDT()  {
    
    let endoint = "https://player.siriusxm.com/rest/v2/experience/modules/get/discover-channel-list?type=2&batch-mode=true&format=json&request-option=discover-channel-list-withpdt&result-template=web"

    let data = GetSync(endpoint: endoint, method: "PDT")
    
    /* get patterns and encrpytion keys */
    let s = data.value( forKeyPath: "ModuleListResponse.moduleList.modules" )!
    let p = s as? NSArray
    let x = p?[0] as! NSDictionary
    let liveChannelResponses = x.value( forKeyPath: "moduleResponse.moduleDetails.liveChannelResponse.liveChannelResponses" ) as! NSArray
    let i = liveChannelResponses[0] as! NSDictionary
    //channelid
    let channelid = i.value( forKeyPath: "channelId" ) as! String
    let markerLists = i.value( forKeyPath: "markerLists" ) as! NSArray
    let cutlayer = markerLists[0]
    let episodelayer = markerLists[1]
    print("-----------")
    print(cutlayer)
    print("-----------")

    print(episodelayer)
    print("-----------")

    print(channelid)
    print("-----------")

   // let chunk = c.value( forKeyPath: "chunks.chunks") as! NSArray
  //  let d = chunk[0] as! NSDictionary
    
}
