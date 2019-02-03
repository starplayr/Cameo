import Foundation

func Config()  {
   let endpoint = Global.variable.http + Global.variable.root +  "/get/configuration?result-template=html5&app-region=US"
    
    print(endpoint)

   let config = GetSync(endpoint: endpoint, method: "config")
    
    /* get patterns and encrpytion keys */
    let s = config.value( forKeyPath: "ModuleListResponse.moduleList.modules" )!
    let p = s as? NSArray
    let x = p![0] as! NSDictionary
    let customAudioInfos = x.value( forKeyPath: "moduleResponse.configuration.components" ) as! NSArray
    //let c = customAudioInfos[0] as! NSDictionary

    let str = "relativeUrls"
    for i in customAudioInfos {
       let a = i as! NSDictionary
        let name = a["name"] as! String
        

        if name == str {
            let streamUrls = a.value( forKeyPath: "settings.relativeUrls" ) as! NSArray
            let streamRoots = (streamUrls[0]) as! NSArray
            for j in streamRoots {
                let b = j as! NSDictionary
                
                if b["name"] != nil && b["url"] as! String != "TBD" {
                    let streamName = b["name"] as! String
                    let streamUrl = b["url"]  as! String
                    Global.variable.hls_sources[streamName] = streamUrl
                }
            }
        }
    }
}
