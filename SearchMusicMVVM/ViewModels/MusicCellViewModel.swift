//
//  MusicCellViewModel.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import Foundation

public struct MusicCellViewModel {
    private let music: Music
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        return dateFormatter
    }()
    
    public var title: String {
        return music.trackName ?? "Not Found"
    }
    
    public var imageURL: String {
        return music.artworkUrl100
    }
    
    public var artistName: String {
        return music.artistName
    }
    
    public var genreName: String {
        return music.primaryGenreName
    }
    
    public var releaseDate: String {
        return dateFormatter.string(from: music.releaseDate)
    }
    
    init(music: Music) {
        self.music = music
    }
}
