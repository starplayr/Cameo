//
//  Login.swift
//  Camouflage
//
//  Created by Todd on 1/20/19.
//

import Foundation

public func Login(user: String, pass: String) -> (success: Bool, message: String, data: String) {

    var email : String? =  ""
    var success : Bool? = false
    var message : String?  = "Username or password is incorrect."
    
    let endpoint = Global.variable.http + Global.variable.root +  "/modify/authentication"
    let method = "login"
    let loginReq = ["moduleList": ["modules": [["moduleRequest": ["resultTemplate": "web", "deviceInfo": ["osVersion": "Mac", "platform": "Web", "sxmAppVersion": "3.1802.10011.0", "browser": "Safari", "browserVersion": "11.0.3", "appRegion": "US", "deviceModel": "K2WebClient", "clientDeviceId": "null", "player": "html5", "clientDeviceType": "web"], "standardAuth": ["username": user , "password": pass ]]]]]] as Dictionary
    
    let result = PostSync(request: loginReq, endpoint: endpoint, method: method )
    
    if (result.response.statusCode) == 403 {
        success = false
        message = "Too many incorrect logins, Sirius XM has blocked your IP for 24 hours."
        return (success: success!, message: message!, data: "")
    }
    
    if result.success {
        var userid : String? = ""
        let r = result.data as NSDictionary
        let d = r.value(forKeyPath: "ModuleListResponse.messages")!
        let a = d as? NSArray
        let cm = a?[0] as! NSDictionary

        let code = cm.value(forKeyPath: "code")! as! Int
        let msg = cm.value(forKeyPath: "message")! as! String
        var logindata : Global.LoginData? = (email:"", pass:"", channels: [:], channel: "", token: "", loggedin: false, guid: "", gupid: "", consumer: "", key: "", keyurl: "" ) as Global.LoginData

        if code == 101 || msg == "Bad username/password" {
            success = false
            message = "Bad username or password/"
            return (success: success!, message: message!, data: "")

        } else {
            success = true
            message = "Login successful"
            let s = r.value(forKeyPath: "ModuleListResponse.moduleList.modules")!
            let p = s as? NSArray
            let x = p?[0] as! NSDictionary
            let y = x.value(forKeyPath: "moduleResponse.authenticationData.username") as! String
            email = y
            logindata!.loggedin = true
            
            //get the GupId Cookie
            let fields = result.response.allHeaderFields as? [String : String]
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields!, for: result.response.url!)
            HTTPCookieStorage.shared.setCookies(cookies, for: result.response.url!, mainDocumentURL: nil)
   
            
            if fields?["GupId"] != nil {
                userid = fields?["GupId"]
                Global.variable.user[userid!] = logindata
                Global.variable.user[userid!]?.gupid = userid!
            }
            
            if email != nil {
                Global.variable.user[userid!]?.email = email!
            }
            
            /*saveKeys for AutoLogin */
            UserDefaults.standard.set(user, forKey: "user")
            UserDefaults.standard.set(pass, forKey: "pass")
            UserDefaults.standard.set(userid, forKey: "userid")
            UserDefaults.standard.set(email, forKey: "email")

            
            return (success: success!, message: message!, data: Global.variable.user[userid!]!.gupid)

        }
    }
    
    email = nil
    success = nil
    message = nil
    return (success: false, message: "To err is human. We had a login failure.", data: "")

}





    


