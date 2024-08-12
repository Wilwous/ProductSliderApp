//
//  Category.swift
//  ProductSliderApp
//
//  Created by Антон Павлов on 10.08.2024.
//

import Foundation

struct Category: Decodable {
    let id: Int
    let name: String
    let products: [ProductModel]

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "NAME"
        case products = "data"
    }
}
