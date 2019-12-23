//
//  Character.swift
//  Peller_Task
//
//  Created by User on 12/20/19.
//  Copyright © 2019 GagikMelikyan. All rights reserved.
//

import Foundation
import UIKit

struct CharctersData: Codable {
    let data: ResultObject
}

struct ResultObject: Codable {
    let total: Int
    let offset: Int
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    let thumbnail: Thumbnail

    var imgPath: String {
        return thumbnail.path + "." + thumbnail.imageFormat
    }
}

struct Thumbnail: Codable {
    let path: String
    let imageFormat: String

    enum CodingKeys: String, CodingKey {
        case path
        case imageFormat = "extension"
    }
}





