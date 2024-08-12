//
//  Service.swift
//  ProductSliderApp
//
//  Created by Антон Павлов on 10.08.2024.
//

import Foundation

// MARK: - Network

final class NetworkManager {
    func fetchData(completion: @escaping (ResponseData?) -> Void) {
        guard let url = URL(
            string: "https://szorin.vodovoz.ru/newmobile/glavnaya/super_top.php?action=topglav"
        ) else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
                    completion(responseData)
                } catch {
                    print("Ошибка декодирования: \(error)")
                    completion(nil)
                }
            } else {
                print("Ошибка загрузки данных: \(String(describing: error))")
                completion(nil)
            }
        }.resume()
    }
}
