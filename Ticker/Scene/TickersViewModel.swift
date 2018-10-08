//
//  TickersViewModel.swift
//  GithubTickersSerfing
//
//  Created by Денис Ефимов on 02.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

final class TickersViewModel: ViewModelType {
    
    struct Input {
        let pollingStart: Observable<Void>
        let pollingStop: Observable<Void>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let tickers: Driver<[TickerItemViewModel]>
        let selectedTicker: Driver<Ticker>
        let error: Driver<Error>
    }
    
    private var timerDisposeBag: DisposeBag?
    private let disposeBag = DisposeBag()
    private let useCase: Domain.TickerUseCase
    private let navigator: TickersNavigator
    private let sheduler: SchedulerType!
    private let trigger = PublishSubject<Void>()
    
    init(useCase: Domain.TickerUseCase, navigator: TickersNavigator) {
        self.useCase = useCase
        self.navigator = navigator
        
        let queueLabel = "den.efimov.backgroundQueue"
        let responseQueue = DispatchQueue(label: queueLabel, qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent)
        self.sheduler = ConcurrentDispatchQueueScheduler.init(queue: responseQueue)
        
        
    }
    
    func transform(input: Input) -> Output {
        
        let errorTracker = ErrorTracker()
        
        let timer = Observable<Int>
            .timer(0, period: 4, scheduler: self.sheduler)

        
        input.pollingStart
            .subscribeOn(sheduler)
            .subscribe(onNext: { [unowned self] _ in
                if self.timerDisposeBag != nil {
                    return
                }
                self.timerDisposeBag = DisposeBag()
                timer.mapToVoid()
                    .debug()
                    .bind(to: self.trigger)
                    .disposed(by: self.timerDisposeBag!)
            }).disposed(by: disposeBag)
        
        _ = input.pollingStop
            .subscribeOn(sheduler)
            .subscribe(onNext: { _ in
            self.timerDisposeBag = nil
        })
        
        
        let items = trigger.flatMapLatest {_ in
            return self.useCase.tickers()
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { TickerItemViewModel(with: $0) } }
        }.asDriverOnErrorJustComplete()
        
        let errors = errorTracker.asDriver()
        let selectedTicker = input.selection
            .withLatestFrom(items) { (indexPath, items) -> Ticker in
                return items[indexPath.row].ticker
            }
            .do(onNext: { ticker in
                // do something with ticker
                debugPrint(ticker)
            })
        
        return Output(
            tickers: items,
            selectedTicker: selectedTicker,
            error: errors)
    }
}
