//
//  PDT.swift
//  CameoKit
//
//  Created by Todd Bruss on 1/27/19.
//

import Foundation
import CommonCrypto

var ArtistSongData = [String: Any ]()

internal func PDT(userid: String) -> [String: Any] {

    let timeInterval = NSDate().timeIntervalSince1970
    let convert = timeInterval * 1000000 as NSNumber
    let intTime = Int(truncating: convert) / 1000
    let time = String(intTime)
    //print (time)
    // let dateFormatter = DateFormatter()
    // let timeZone = TimeZone(identifier: "EST")
    // dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm.sss+SSSS"
    // dateFormatter.timeZone = timeZone
    // let timeStamp = dateFormatter.string(from: Date())
    // print(timeStamp)
    
    let endoint = "https://player.siriusxm.com/rest/v2/experience/modules/get/discover-channel-list?&batch-mode=true&format=json&request-option=discover-channel-list-withpdt&result-template=web&time=" + time

    let data = GetSync(endpoint: endoint, method: "PDT")

    if let s = data.value( forKeyPath: "ModuleListResponse.moduleList.modules" ) {
        let p = s as? NSArray
        let x = p?[0] as! NSDictionary
        let liveChannelResponses = x.value( forKeyPath: "moduleResponse.moduleDetails.liveChannelResponse.liveChannelResponses" ) as? NSArray
        
        for j in liveChannelResponses! {
            
            let i = j as? NSDictionary
            let channelid = i!.value( forKeyPath: "channelId" ) as? String
            let markerLists = i!.value( forKeyPath: "markerLists" ) as? NSArray
            let cutlayer = markerLists!.firstObject as? NSDictionary
            let markers = cutlayer!.value( forKeyPath: "markers" ) as? NSArray
            
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
                    let a = artists![0] as! NSDictionary
                    let artist = a.value( forKeyPath: "name" ) as? String
                    
                    let key = MD5(artist! + song!);
                    
                    Global.variable.MemBase[key!] = ["thumb": thumb!, "image" : image!, "artist": artist!, "song" : song!]
                }
            }
            
            
            let item = markers!.firstObject as? NSDictionary
            if let cut = item!.value( forKeyPath: "cut" ) as? NSDictionary {
                let song = cut.value( forKeyPath: "title" ) as? String
                let artists = cut.value( forKeyPath: "artists" ) as? NSArray
                let a = artists!.firstObject as? NSDictionary
                let artist = a!.value( forKeyPath: "name" ) as? String
                
                let key = MD5(artist! + song!);
                
                var image = ""
                var thumb = ""
                if let art = Global.variable.MemBase[key!] as? NSDictionary {
                    image = art["image"] as! String
                    thumb = art["thumb"] as! String
                }
                // let episodelayer = markerLists[1]
                
                if userid != "" {
                    let ch = Global.variable.user[userid]!.channels
                    if ch.count > 1 {
                        
                        for i in ch {
                            let k = i.value as! [String: String]
                            let j = k["channelId"]! as String
                            
                            if j == channelid {
                                let n = k["channelNumber"]! as String
                                
                                ArtistSongData[n] = ["artist":artist,"song":song, "image":image,   "thumb":thumb]
                                
                                break
                            }
                        }
                    }
                }
            }
            
        }
        
        /*
        let queue = DispatchQueue.init(label: "MemBase")
        queue.async {
            // run your server here.
            do {
                //save to disk
                if Global.variable.MemBase.count > 0 {
                    let writeMemBase = NSKeyedArchiver.archivedData(withRootObject: Global.variable.MemBase)
                    UserDefaults.standard.set(writeMemBase, forKey: "MemBase")
                }
            }
        }
        */
    }
    
    
  
    
   
    
    
    return ArtistSongData
    //print(i)
    //channelid

  

   // let chunk = c.value( forKeyPath: "chunks.chunks") as! NSArray
  //  let d = chunk[0] as! NSDictionary

}

/*
aodEpisodeCount = 0;
channelId = siriushits1;
markerLists =     (
    {
        layer = cut;
        markers =             (
            {
                assetGUID = "05176e45-d3ed-4e87-03f3-4ae75723bb25";
                consumptionInfo = "gi=GDCA-101310964-001,c=siriushits1,d=18000,si=22bba56a,ms=2019-02-12T02:19:50Z,ag=05176e45-d3ed-4e87-03f3-4ae75723bb25";
                containerGUID = "194adbca-34d6-cb94-b153-3488ee563308";
                cut =                     {
                    album =                         {
                        title = Natural;
                    };
                    artists =                         (
                        {
                            name = "Imagine Dragons";
                        }
                    );
                    cutContentType = Song;
                    galaxyAssetId = "GDCA-101310964-001";
                    legacyIds =                         {
                        siriusXMId = 22bba56a;
                    };
                    mref = 213001;
                    title = Natural;
                };
                layer = cut;
                time = 1549937990000;
                timestamp =                     {
                    absolute = "2019-02-12T02:19:50.000+0000";
                };
            }
        );
},
    {
        layer = episode;
        markers =             (
            {
                assetGUID = "15c34af7-4986-ff98-6ddd-035b85f75edf";
                duration = 10800;
                episode =                     {
                    isLiveVideoEligible = 0;
                    show =                         {
                        aodEpisodeCount = 0;
                        guid = "67cb58e6-305e-3599-85c4-a1e3ef216662";
                        isLiveVideoEligible = 0;
                        isPlaceholderShow = 0;
                        longTitle = "Hits 1 In Hollywood";
                        programType = "Talk Show";
                        showGUID = "67cb58e6-305e-3599-85c4-a1e3ef216662";
                        vodEpisodeCount = 0;
                    };
                };
                layer = episode;
                time = 1549929600000;
                timestamp =                     {
                    absolute = "2019-02-12T00:00:00.000+0000";
                };
            }
        );
}
);
}
 */

func MD5(_ string: String) -> String? {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    var digest = [UInt8](repeating: 0, count: length)
    
    if let d = string.data(using: String.Encoding.utf8) {
        _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
            CC_MD5(body, CC_LONG(d.count), &digest)
        }
    }
    
    return (0..<length).reduce("") {
        $0 + String(format: "%02x", digest[$1])
    }
}
