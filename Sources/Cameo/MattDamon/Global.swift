import Foundation

//constants
var hls_sources = Dictionary<String, String>()

var usePrime = true
let http = "https://"
let root = "player.siriusxm.com/rest/v2/experience/modules"

var gChannels = Dictionary<String, Any>()
var gLoggedinUser = "starplayr@icloud.com"
var gUser = Dictionary<String, (pass:String, channel: String, token: String, loggedin: Bool, guid: String, gupid: String, consumer: String, key: String, keyurl: String )>()

//Future
//URL: https://player.siriusxm.com/rest/v2/experience/modules/get/discover-channel-list?type=2&batch-mode=true&format=json&request-option=discover-channel-list-withpdt&result-template=web&time=1548615083793

//On Ice
//URL: https://player.siriusxm.com/rest/v4/experience/modules/tune/now-playing-live?channelId=thepulse&hls_output_mode=none&marker_mode=all_separate_cue_points&ccRequestType=AUDIO_VIDEO&result-template=web&time=1548615098681

