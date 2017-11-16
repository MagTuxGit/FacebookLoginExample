//
//  ViewController.swift
//  FacebookLoginExample
//
//  Created by Andriy Trubchanin on 11/16/17.
//  Copyright © 2017 Trand. All rights reserved.
//

import UIKit

/*
 - developers.facebook.com project setup
 - Pod
 - Info.plist
 - AppDelegate
 */

class ViewController: UIViewController {

    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var userPicture: UIImageView!
    
    let facebookService = FacebookService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        infoLabel.numberOfLines = 0
    }
    
    @IBAction func loginTouched(_ sender: UIButton) {
        facebookService.login(viewController: self) { [weak self] userInfo, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let userInfo = userInfo else {
                print("undefined error")
                return
            }
            
            self?.infoLabel.text = "ID: \(userInfo.id) \nName: \(userInfo.name) \nEmail: \(userInfo.email)"
            
            if let pictureUrl = URL(string: userInfo.picture.data.url) {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    if let urlContents = try? Data(contentsOf: pictureUrl) {
                        DispatchQueue.main.async {
                            self?.userPicture.image = UIImage(data: urlContents)
                        }
                    }
                }
            }
        }
    }

}

