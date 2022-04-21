//
//  UserResponse.swift
//  VKAppNews
//
//  Created by Max Pavlov on 21.04.22.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
