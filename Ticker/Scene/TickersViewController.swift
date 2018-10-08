//
//  TickersViewController.swift
//  GithubTickersSerfing
//
//  Created by Денис Ефимов on 02.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip
import Domain
import SnapKit

class TickersViewController: UIViewController, IndicatorInfoProvider {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let disposeBag = DisposeBag()
    
    var viewModel: TickersViewModel!
    
    private var itemInfo: IndicatorInfo = "Котировки"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        self.view.addSubview(tableView)
        tableView.register(TickerTableViewCell.self, forCellReuseIdentifier: "TickerTableViewCell")
        return tableView
    }()
    
    private lazy var errorBinding = Binder<Error>(self) { (vc, error) in
        
        debugPrint(error)
        
        let alert = UIAlertController(title: "Ошибка соединения",
                                      message: "Пожалуйста, повторите попытку позднее",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК",
                                   style: .cancel,
                                   handler: nil)
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        
    }
    
    private func configureUI() {
        
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        tableView.snp.makeConstraints { maker in
            maker.edges.equalTo(self.view)
        }
        
        configureTableView()
    }
    
    private func configureTableView() {
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    private func bindViewModel() {
        
        assert(viewModel != nil)
        
        let viewWillAppear = rx
            .sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
        
        let noteBecomeActive = NotificationCenter
            .default.rx
            .notification(NSNotification.Name.NSExtensionHostDidBecomeActive)
            .mapToVoid()
        
        let willEnterForeground = NotificationCenter
            .default.rx
            .notification(NSNotification.Name.NSExtensionHostWillEnterForeground)
            .mapToVoid()
        
        let viewWillDisappear = rx.sentMessage(#selector(UIViewController.viewWillDisappear(_:)))
            .mapToVoid()
        
        let WillResignActive = NotificationCenter.default.rx
            .notification(NSNotification.Name.NSExtensionHostWillResignActive)
            .debug()
            .mapToVoid()
        
        let DidEnterBackground = NotificationCenter.default.rx
            .notification(NSNotification.Name.NSExtensionHostDidEnterBackground)
            .debug()
            .mapToVoid()
        
        let input = TickersViewModel.Input(pollingStart: Observable.merge(viewWillAppear, noteBecomeActive, willEnterForeground),
                                           pollingStop: Observable.merge(viewWillDisappear, WillResignActive, DidEnterBackground),
                                           selection: tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.tickers.drive(tableView.rx.items(cellIdentifier: TickerTableViewCell.reuseID, cellType: TickerTableViewCell.self)) { _, viewModel, cell in
                cell.bind(viewModel)
            }.disposed(by: disposeBag)
        
        output.selectedTicker
            .drive()
            .disposed(by: disposeBag)
        
        output.error
            .drive(errorBinding)
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - PagerTabStrip
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
}

extension TickersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


