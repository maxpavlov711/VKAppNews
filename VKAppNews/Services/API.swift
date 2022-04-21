//
//  API.swift
//  VKAppNews
//
//  Created by Max Pavlov on 25.03.22.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131"
    
    static let newsFeed = "/method/newsfeed.get"
    static let user = "/method/users.get"
}
