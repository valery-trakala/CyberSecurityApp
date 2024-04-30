//
//  NetworkDataFetcher.swift
//  CyberSecurityApp
//
//  Created by Valery Trakala on 29/04/2024.
//

import Foundation

protocol DataFetcherProtocol {
    func getCategories() async throws -> [CategoriesModelResponse]?
    func getNotifications(categoryId: Int, page: Int , pageSize: Int) async throws -> [CategoryNotificationModelResponse]?
}

final class CategoriesDataFetcher: DataFetcherProtocol {
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func getCategories() async throws -> [CategoriesModelResponse]? {
        do {
            let path = "https://threats.chipp.dev/categories"
            
            guard let url = URL(string: path) else {
                print("Invalid URL")
                return nil
            }
            let request = createRequest(url: url, params: nil)
            
            let (data, _) = try await urlSession.data(for: request)
            guard let response = decodeJSON(type: [CategoriesModelResponse].self, data: data) else { return nil }
            
            return response
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getNotifications(categoryId: Int, page: Int = 1, pageSize: Int = 3) async throws -> [CategoryNotificationModelResponse]? {
        let path = "https://threats.chipp.dev/categories/\(categoryId)/threats"
        
        guard let url = URL(string: path) else {
            print("Invalid URL")
            return nil
        }
        
        let params = ["page": String(page), "pageSize": String(pageSize)]
        let request = createRequest(url: url, params: params)
        
        let (data, _) = try await urlSession.data(for: request)
        guard let response = decodeJSON(type: [CategoryNotificationModelResponse].self, data: data) else { return nil }
        
        return response
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type ,data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let data = data, let response = try? decoder.decode(T.self, from: data) else {
            print("Decoding error")
            return nil
        }
        return response
    }
    
    private func createRequest(url: URL, params: [String: String]?) -> URLRequest {
        var request = URLRequest(url: url)
        let requestId = UUID().uuidString
        request.addValue(requestId, forHTTPHeaderField: "X-Request-Id")

        guard let params = params, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return request }

        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        request.url = components.url
        
        return request
    }
}
