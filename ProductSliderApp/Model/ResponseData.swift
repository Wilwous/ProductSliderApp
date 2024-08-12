//
//  ResponseData.swift
//  ProductSliderApp
//
//  Created by Антон Павлов on 10.08.2024.
//

import Foundation

struct ResponseData: Decodable {
    let status: String
    let categories: [Category]

    enum CodingKeys: String, CodingKey {
        case status
        case categories = "TOVARY"
    }
}
