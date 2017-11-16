//
//  FacebookUserInfo.swift
//  FacebookLoginExample
//
//  Created by Andriy Trubchanin on 11/16/17.
//  Copyright © 2017 Trand. All rights reserved.
//

import Foundation

struct FacebookUserInfo: Codable {
    let email: String
    let id: String
    let name: String
    let picture: Picture
}

struct Picture: Codable {
    struct PictureData: Codable {
        let url: String
        
        enum CodingKeys: String, CodingKey {
            case url = "url"
        }
        
    }
    let data: PictureData
}

extension FacebookUserInfo {
    static func from(json: String, using encoding: String.Encoding = .utf8) -> FacebookUserInfo? {
        guard let data = json.data(using: encoding) else { return nil }
        return from(data: data)
    }
    
    static func from(json: [String:Any]?) -> FacebookUserInfo? {
        guard let json = json, let data = try? JSONSerialization.data(withJSONObject: json) else { return nil }
        return from(data: data)
    }
    
    static func from(data: Data) -> FacebookUserInfo? {
        let decoder = JSONDecoder()
        return try? decoder.decode(FacebookUserInfo.self, from: data)
    }
    
    var jsonData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension FacebookUserInfo {
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case id = "id"
        case name = "name"
        case picture = "picture"
    }
}

extension Picture {
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}
