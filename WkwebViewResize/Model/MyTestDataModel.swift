//
//  MyTestDataModel.swift
//  WkwebViewResize
//
//  Created by Çağan Kiraz on 7.04.2020.
//  Copyright © 2020 gelasdev. All rights reserved.
//

import Foundation

struct MyTestDataModel: Decodable {
    let text: String
    
    private enum CodingKeys : String, CodingKey {
        case text = "Text"
    }
}
