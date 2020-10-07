//
//  URLComponents+Extension.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 23/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import Foundation


extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    mutating func appendQueryItems(with parameters: [String: String]) {
        queryItems?.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: $0.value) })
    }
}
