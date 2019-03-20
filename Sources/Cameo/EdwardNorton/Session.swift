//
//  Cookies.swift
//  Camouflage
//
//  Created by Todd Bruss on 1/20/19.
//

import Foundation


internal func Session(channelid: String, userid: String) -> String {
    
    let endpoint = Global.variable.http + Global.variable.root + "/resume?channelId=" + channelid + "&contentType=live"
    let request =  ["moduleList": ["modules": [["moduleRequest": ["resultTemplate": "web", "deviceInfo": ["osVersion": "Mac", "platform": "Web", "clientDeviceType": "web", "sxmAppVersion": "3.1802.10011.0", "browser": "Safari", "browserVersion": "11.0.3", "appRegion": "US", "deviceModel": "K2WebClient", "player": "html5", "clientDeviceId": "null"]]]]]] as Dictionary
    
    //MARK - for Sync
    let semaphore = DispatchSemaphore(value: 0)
    let http_method = "POST"
    let time_out = 30
    let url = URL(string: endpoint)
    var urlReq : URLRequest? = URLRequest(url: url!)
    
    urlReq!.httpBody = try? JSONSerialization.data(withJSONObject: request, options: .prettyPrinted)
    urlReq!.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlReq!.httpMethod = http_method
    
    urlReq!.timeoutInterval = TimeInterval(time_out)
    urlReq!.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.2 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
    
    let task = URLSession.shared.dataTask(with: urlReq! ) { ( rData, resp, error ) in
    
        if let r = resp as? HTTPURLResponse {
            if r.statusCode == 200 {
                
                do { let result =
                    try JSONSerialization.jsonObject(with: rData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
                    
                    let fields = r.allHeaderFields as? [String : String]
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields!, for: r.url!)
                    HTTPCookieStorage.shared.setCookies(cookies, for: r.url!, mainDocumentURL: nil)
                    
                    for cookie in cookies {
                        
                        //This token changes on every pull and expires in about 480 seconds or less
                        if cookie.name == "SXMAKTOKEN" {
                            
                            let t = cookie.value as String
                            let startIndex = t.index(t.startIndex, offsetBy: 3)
                            let endIndex = t.index(t.startIndex, offsetBy: 45)
                            Global.variable.user[userid]?.token = String(t[startIndex...endIndex])
                            break
                        }
                    }
                    
                    let dict = result as NSDictionary?
                    
                    
                    
                    /* get patterns and encrpytion keys */
                    let s = dict?.value( forKeyPath: "ModuleListResponse.moduleList.modules" )
                    let p = s as? NSArray
                    let x = p?[0] as? NSDictionary
                    if let customAudioInfos = x!.value( forKeyPath: "moduleResponse.liveChannelData.customAudioInfos" ) as? NSArray {
                        let c = customAudioInfos[0] as? NSDictionary
                        let chunk = c!.value( forKeyPath: "chunks.chunks") as? NSArray
                        let d = chunk![0] as? NSDictionary
                        
                        Global.variable.user[userid]?.key = d!.value( forKeyPath: "key") as! String
                        Global.variable.user[userid]?.keyurl = d!.value( forKeyPath: "keyUrl") as! String
                        Global.variable.user[userid]?.consumer  = x!.value( forKeyPath: "moduleResponse.liveChannelData.hlsConsumptionInfo" ) as! String
                    }
                    
                    if let markerLists = x!.value( forKeyPath: "moduleResponse.liveChannelData.markerLists" )  as? NSArray {
                        
                        let markerDict = markerLists.lastObject as? NSDictionary
                        let cutLayer = markerDict!.value( forKeyPath: "layer") as? String
                        
                        if cutLayer == "cut" {
                            let markers = markerDict!.value( forKeyPath: "markers") as? NSArray
                            
                            //MemBase saves album art with Artist and Song info
                            for g in markers! {
                                let gather = g as? NSDictionary
                                //grabs the album art code number
                                if let art = gather!.value( forKeyPath: "cut.album.creativeArts" ) as? NSArray {
                                    
                                    let thumbnail = art.firstObject! as? NSDictionary
                                    let thumb = thumbnail?.value( forKeyPath: "url" ) as? String
                                    
                                    let large = art.lastObject! as? NSDictionary
                                    let image = large?.value( forKeyPath: "url" ) as? String
                                    
                                    let cut = gather!.value( forKeyPath: "cut" ) as? NSDictionary
                                    let song = cut!.value( forKeyPath: "title" ) as? String
                                    let artists = cut!.value( forKeyPath: "artists" ) as? NSArray
                                    let a = artists!.firstObject as? NSDictionary
                                    let artist = a!.value( forKeyPath: "name" ) as? String
                                    
                                    let key = MD5(artist! + song!);
                                    Global.variable.MemBase[key!] = ["thumb": thumb!, "image" : image!, "artist": artist!, "song" : song!]
                                }
                            }
                        }
                        
                    }
                    
                    //moduleResponse.liveChannelData.markerLists
                    
                } catch {
                    //fail on any errors
                    print(error)
                }
            }
            
        }
        
  
        //MARK - for Sync
        semaphore.signal()
    }
    
    task.resume()
    _ = semaphore.wait(timeout: .distantFuture)
    
    urlReq = nil
    
    if  Global.variable.user[userid]?.token != nil {
        
        return  (Global.variable.user[userid]?.token)!
    } else {
        return ""
    }
}
