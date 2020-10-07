//
//  Music.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import Foundation

struct MusicResponse: Decodable {
    let resultCount: Int
    let results: [Music]
}

struct Music: Decodable {
    let artistName: String
    var trackName: String?
    let artworkUrl100: String
    let primaryGenreName: String
    let releaseDate: Date
}
