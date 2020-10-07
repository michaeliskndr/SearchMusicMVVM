//
//  API.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import Foundation


public class API: MusicService {
    public static let shared = API()
    private let session: URLSession = .shared
    private let baseURL =  "https://itunes.apple.com/search"
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    private init() { }
    
    func fetchMusics(completion: @escaping (Result<MusicResponse, APIError>) -> Void) {
        fetchResources(params: ["media": "music",
                                "term": "home"],
                       completion: completion)
    }
    
    func searchMusic(query: String, limit: Int = 25, offset: Int = 0, completion: @escaping (Result<MusicResponse, APIError>) -> Void) {
        fetchResources(params: ["media": "music",
                                "term": query,
                                "limit": String(limit),
                                "offset": String(offset)],
                       completion: completion)
    }
    
    private func fetchResources<T: Decodable>(params: [String: String]?, completion: @escaping (Result<T, APIError>) -> Void) {
        guard var component = URLComponents(string: baseURL) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        if let params = params {
            component.setQueryItems(with: params)
        }
                
        guard let url = component.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let results = try self.decoder.decode(T.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
}


