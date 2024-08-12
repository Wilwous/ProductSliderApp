//
//  ProductModel.swift
//  ProductSliderApp
//
//  Created by Антон Павлов on 09.08.2024.
//

import Foundation

struct ProductModel: Decodable {
    let id: String
    let name: String?
    let detailPicture: String?
    let rating: Double?
    let price: Double?
    let morePhotos: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "NAME"
        case detailPicture = "DETAIL_PICTURE"
        case rating = "PROPERTY_RATING_VALUE"
        case price = "EXTENDED_PRICE"
        case morePhotos = "MORE_PHOTO"
    }
    
    enum PriceKeys: String, CodingKey {
        case price = "PRICE"
    }
    
    enum MorePhotoKeys: String, CodingKey {
        case value = "VALUE"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        detailPicture = try container.decodeIfPresent(String.self, forKey: .detailPicture)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        
        if var priceArray = try? container.nestedUnkeyedContainer(forKey: .price) {
            var tempPrice: Double = 0.0
            while !priceArray.isAtEnd {
                let priceValues = try priceArray.nestedContainer(keyedBy: PriceKeys.self)
                tempPrice = try priceValues.decode(Double.self, forKey: .price)
            }
            price = tempPrice
        } else {
            price = nil
        }
        
        if let morePhotosContainer = try? container.nestedContainer(
            keyedBy: MorePhotoKeys.self,
            forKey: .morePhotos
        ) {
            morePhotos = try morePhotosContainer.decode([String].self, forKey: .value)
        } else {
            morePhotos = nil
        }
    }
}



