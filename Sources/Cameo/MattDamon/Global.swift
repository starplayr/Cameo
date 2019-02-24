import Foundation

//Future
//URL: https://player.siriusxm.com/rest/v2/experience/modules/get/discover-channel-list?type=2&batch-mode=true&format=json&request-option=discover-channel-list-withpdt&result-template=web&time=1548615083793

//On Ice
//URL: https://player.siriusxm.com/rest/v4/experience/modules/tune/now-playing-live?channelId=thepulse&hls_output_mode=none&marker_mode=all_separate_cue_points&ccRequestType=AUDIO_VIDEO&result-template=web&time=1548615098681

public class Global {
    
    //streaming flag
    public var streaming: Bool = false
    
    //local
    public let ipaddress: String = "127.0.0.1"
    public var port: Int = 2222
    //source
    public var usePrime: Bool = false
    public let http: String = "https://"
    public let root: String = "player.siriusxm.com/rest/v2/experience/modules"
    
    public var hls_sources = Dictionary<String, String>()
    public var MemBase = [ String : Any ]()
    
    public typealias LoginData = (email:String, pass:String, channels:  Dictionary<String, Any>, channel: String, token: String, loggedin: Bool, guid: String, gupid: String, consumer: String, key: String, keyurl: String )
    public typealias User = Dictionary<String, LoginData>
    public var user: User = User()
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
   public class var variable: Global {
        struct Static {
            static public let instance = Global()
        }
        return Static.instance
    }
}
