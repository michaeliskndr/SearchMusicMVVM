//
//  MusicListViewViewModel.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import Foundation

public final class MusicListViewViewModel {
    private let service: MusicService
    private var _error: APIError?
    private var timer: Timer?
    private var _query: String? = "home"
    private(set) var description: String = "Welcome to our home"
    private(set) var cells: [Cell] = []
    public var isFetching: Bool = false
    public var isPaginating: Bool = false
    public var isDonePaginating: Bool = false
    public var hasError: Bool {
        return _error != nil
    }
    public var errorDescription: String? {
        return _error?.description
    }
    public var title: String {
        return "Hello \(_query?.capitalized ?? "not found")"
    }
    public var numberOfItemsInSection: Int {
        return cells.count
    }
    
    public var reload: () -> () = {}
    public var errorHandler: () -> () = {}
    
    public enum Cell {
        case musicList(MusicCellViewModel)
    }
    
    init(service: MusicService = API.shared) {
        self.service = service
    }
    
    public func cellForRow(at indexPath: IndexPath) -> Cell {
        let music = cells[indexPath.item]
        return music
    }
}

extension MusicListViewViewModel {
    public func fetchMusics() {
        isFetching = !isFetching
        service.fetchMusics { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self._error = error
                DispatchQueue.main.async {
                    self.isFetching = !self.isFetching
                    self.errorHandler()
                }
            case .success(let response):
                self.cells = []
                self.cells = response.results.map {
                    return Cell.musicList(MusicCellViewModel(music: $0))
                }
                DispatchQueue.main.async {
                    self.isFetching = !self.isFetching
                    self.reload()
                }
            }
        }
    }
    
    public func searchMusics(query: String) {
        self._query = query
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.service.searchMusic(query: query, limit: 25, offset: self.cells.count) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self._error = error
                    DispatchQueue.main.async {
                        self.errorHandler()
                    }
                case .success(let response):
                    self.cells = []
                    self.cells = response.results.map {
                        return Cell.musicList(MusicCellViewModel(music: $0))
                    }
                    DispatchQueue.main.async {
                        self.reload()
                    }
                }
            }
        }
    }
    
    public func fetchMoreData() {
        guard let query = _query, cells.count > 0 else { return }
        self.isPaginating = !self.isPaginating
        let offset = cells.count
        service.searchMusic(query: query, limit: 25, offset: offset) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .failure(let error):
                self._error = error
                DispatchQueue.main.async {
                    self.errorHandler()
                }
            case .success(let response):
                sleep(2)
                if response.results.count == 0 {
                    self.isDonePaginating = true
                    return
                }
                self.cells += response.results.map {
                    let musicCellViewModel = MusicCellViewModel(music: $0)
                    return Cell.musicList(musicCellViewModel)
                }
                self.isPaginating = !self.isPaginating
                DispatchQueue.main.async {
                    self.reload()
                }
            }
        }
    }
}
