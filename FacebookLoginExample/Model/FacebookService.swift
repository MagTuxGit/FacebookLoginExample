//
//  FacebookService.swift
//  FacebookLoginExample
//
//  Created by Andriy Trubchanin on 11/16/17.
//  Copyright © 2017 Trand. All rights reserved.
//

import Foundation
import FacebookCore     // for GraphRequest
import FacebookLogin    // for LoginButton and LoginManager

class FacebookService {
    
    func login(viewController: UIViewController, completion: @escaping (_ response:FacebookUserInfo?, _ error: Error?)->()) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [.publicProfile, .email, .userBirthday], viewController: viewController) { [weak self] result in
            switch result {
            case .failed(let error):
                completion(nil, error)
            case .cancelled:
                completion(nil, nil)
            case .success(let grantedPermissions, let declinedPermissions, let userInfo):
                // Here the info you can get
                let _ = userInfo.appId
                let _ = userInfo.authenticationToken
                let _ = userInfo.expirationDate
                let _ = userInfo.refreshDate
                let _ = userInfo.userId
                let _ = userInfo.grantedPermissions
                let _ = userInfo.declinedPermissions
                
                let _ = grantedPermissions.map({ "\($0)" } ).joined(separator: " ")
                let _ = declinedPermissions.map({ "\($0)" } ).joined(separator: " ")
                
                // Call our func
                self?.getUserInfo { userInfo, error in
                    let userInfo = FacebookUserInfo.from(json: userInfo)
                    completion(userInfo, error)
                }
            }
        }
    }
    
    func getUserInfo(completion: @escaping (_ response:[String:Any]?, _ error: Error?)->()) {
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"id,name,email,picture"])
        
        request.start { (response, result) in
            switch result {
            case .failed(let error):
                completion(nil, error)
            case .success(let graphResponse):
                completion(graphResponse.dictionaryValue, nil)
            }
        }
    }
}
