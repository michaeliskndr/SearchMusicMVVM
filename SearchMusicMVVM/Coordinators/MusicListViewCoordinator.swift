//
//  MusicListViewCoordinator.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import UIKit

final class MusicListViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let router: UINavigationController
    
    init(router: UINavigationController) {
        self.router = router
    }
    
    func start() {
        let viewModel = MusicListViewViewModel(service: API.shared)
        let controller: MusicListViewController = MusicListViewController(viewModel: viewModel)
        router.setViewControllers([controller], animated: true)
    }
    
}
