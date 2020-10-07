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
    let presenter: UINavigationController
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let viewModel = MusicListViewViewModel(service: API.shared)
        let controller: MusicListViewController = MusicListViewController(viewModel: viewModel)
        presenter.setViewControllers([controller], animated: true)
    }
    
}
