//
//  PostsNavigator.swift
//  GithubTickersSerfing
//
//  Created by Денис Ефимов on 02.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import UIKit
import Domain

protocol TickersNavigator {
    func configureTickersViewController() -> TickersViewController
    func toTickers() -> Void
}

class DefaultTickersNavigator: TickersNavigator {
    
    private let navigationController: UINavigationController
    private let services: Domain.UseCaseProvider
    
    init(services: Domain.UseCaseProvider,
         navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func configureTickersViewController() -> TickersViewController {
        let vc = TickersViewController()
        vc.viewModel = TickersViewModel(useCase: services.makeTickersUseCase(), navigator: self)
        return vc
    }
    
    func toTickers() {
        let vc = TickersViewController()
        vc.viewModel = TickersViewModel(useCase: services.makeTickersUseCase(), navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
