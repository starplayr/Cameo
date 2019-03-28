//
//  Cookies.swift
//  Camouflage
//
//  Created by Todd Bruss on 1/20/19.
//

//carousel
//URL: https://player.siriusxm.com/rest/v4/experience/carousels?page-name=recents&result-template=everest%7Cweb&cacheBuster=1553640589533

//refresh tracks
//URL: https://player.siriusxm.com/rest/v4/aic/refresh-tracks?cacheBuster=1553640744078

//tune
//
//  Cookies.swift
//  Camouflage
//
//  Created by Todd Bruss on 1/20/19.
//

//carousel
//URL: https://player.siriusxm.com/rest/v4/experience/carousels?page-name=recents&result-template=everest%7Cweb&cacheBuster=1553640589533

//refresh tracks
//URL: https://player.siriusxm.com/rest/v4/aic/refresh-tracks?cacheBuster=1553640744078

//tune
//https://player.siriusxm.com/rest/v4/aic/tune?channelGuid=86d52e32-09bf-a02d-1b6b-077e0aa05200&cacheBuster=1553640887848

import Foundation

internal func XtraTune(channelid: String, userid: String) -> String {
    
    //resume
    let endpoint = "https://player.siriusxm.com/rest/v4/aic/tune?channelGuid=86d52e32-09bf-a02d-1b6b-077e0aa05200"
    
    
    
    let returnData = GetSync(endpoint: endpoint, method: "XtraTune")    //MARK - for Sync
    
    print(returnData)
    
    
    return("FooBar")
  
}
//
//  Cookies.swift
//  Camouflage
//
//  Created by Todd Bruss on 1/20/19.
//
