import Foundation

//Future
//URL: https://player.siriusxm.com/rest/v2/experience/modules/get/discover-channel-list?type=2&batch-mode=true&format=json&request-option=discover-channel-list-withpdt&result-template=web&time=1548615083793

//On Ice
//URL: https://player.siriusxm.com/rest/v4/experience/modules/tune/now-playing-live?channelId=thepulse&hls_output_mode=none&marker_mode=all_separate_cue_points&ccRequestType=AUDIO_VIDEO&result-template=web&time=1548615098681

class Global {
    
    //streaming flag
    internal var streaming: Bool = false
    
    //local
    internal let ipaddress: String = "127.0.0.1"
    internal let port: Int = 1111
    
    //source
    internal var usePrime: Bool = false
    internal let http: String = "http://"
    internal let root: String = "player.siriusxm.com/rest/v2/experience/modules"
    
    internal var hls_sources = Dictionary<String, String>()

    internal typealias LoginData = (email:String, pass:String, channels:  Dictionary<String, Any>, channel: String, token: String, loggedin: Bool, guid: String, gupid: String, consumer: String, key: String, keyurl: String )
    internal typealias User = Dictionary<String, LoginData>
    internal var user: User = User()
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var variable: Global {
        struct Static {
            static let instance = Global()
        }
        return Static.instance
    }
}
