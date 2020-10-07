//
//  MusicService.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import Foundation

protocol MusicService {
    func fetchMusics(completion: @escaping (Result<MusicResponse, APIError>) -> Void) 
    func searchMusic(query: String, limit: Int, offset: Int, completion: @escaping (Result<MusicResponse, APIError>) -> Void)
}

public enum APIError: Error, CustomStringConvertible {
    case invalidEndpoint
    case invalidResponse
    case decodingFailed
    case invalidData
    case apiError
    
    public var description: String {
        switch self {
        case .invalidEndpoint: return "Failed to construct endpoint"
        case .invalidData: return "Data not found"
        case .invalidResponse: return "Failed to connect to server, no response"
        case .apiError: return "Failed to fetch API"
        case .decodingFailed: return "Failed to decode JSON"
        }
    }
}
