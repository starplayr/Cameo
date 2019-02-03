//
//  PDT.swift
//  Camouflage
//
//  Created by Todd on 1/27/19.
//

import Foundation

//URL: https://player.siriusxm.com/rest/v2/experience/modules/get/discover-channel-list?type=2&batch-mode=true&format=json&request-option=discover-channel-list-withpdt&result-template=web&time=1548615083793

func PDT(channelId: String )  {
    
    let endoint = "https://player.siriusxm.com/rest/v2/experience/modules/get/discover-channel-list?type=2&batch-mode=true&format=json&request-option=discover-channel-list-withpdt&result-template=web"

    let data = GetSync(endpoint: endoint, method: "PDT")
    print(data)
}
