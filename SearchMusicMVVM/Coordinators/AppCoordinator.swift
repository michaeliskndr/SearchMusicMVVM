//
//  AppCoordinator.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func start()
    func childDidFinish(_ coordinator: Coordinator)
}

extension Coordinator {
    func childDidFinish(_ coordinator: Coordinator) { }
}

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let router = UINavigationController()
        let coordinator = MusicListViewCoordinator(router: router)
        childCoordinators.append(coordinator)
        coordinator.start()
        window.rootViewController = router
        window.makeKeyAndVisible()
    }
}
