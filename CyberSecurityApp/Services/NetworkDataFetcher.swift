//
//  NetworkDataFetcher.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import Foundation

final class NetworkDataFetcher {
    func getCategories() async throws -> [CategoriesResponse]? {
        let path = "https://threats.chipp.dev/categories"
        guard let url = URL(string: path) else {
            print("Invalid URL")
            return nil
        }
        
        let request = createRequest(url: url)

        let (data, _) = try await URLSession.shared.data(for: request)
        guard let response = decodeJSON(type: [CategoriesResponse].self, data: data) else { return nil }
        
        return response
    }
    
    func getNotifications(categoryId: Int) async throws -> [CategoryNotification]? {
        let path = "https://threats.chipp.dev/categories/\(categoryId)/threats"
        guard let url = URL(string: path) else {
            print("Invalid URL")
            return nil
        }
        
        let request = createRequest(url: url)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let response = decodeJSON(type: [CategoryNotification].self, data: data) else { return nil }
        
        return response
    }
        
    private func decodeJSON<T: Decodable>(type: T.Type ,data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = data, let response = try? decoder.decode(T.self, from: data) else {
            print("Decoding error")
            return nil
        }
        return response
    }
    
    private func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        let requestId = UUID().uuidString
        request.addValue(requestId, forHTTPHeaderField: "X-Request-Id")
        
        return request
    }
}
