//
//  Hit.swift
//  HNMobileTest
//
//  Created by Diego Sepúlveda on 5/29/19.
//  Copyright © 2019 reigndesign. All rights reserved.
//

import Foundation

struct News:Codable {
    var params:String
    var query:String
    var hits : [Hit]
}

struct Hit:Codable {

    var storyTitle:String?
    var createdAtI:Int?
    var createdAt:String?
    var storyUrl:String?
    var author:String?
    var title:String?
    var objectId:String?

    private enum CodingKeys: String, CodingKey {
        case storyTitle = "story_title"
        case createdAtI = "created_at_i"
        case createdAt = "created_at"
        case storyUrl = "story_url"
        case objectId = "objectID"
        case author = "author"
        case title = "title"
    }
}
