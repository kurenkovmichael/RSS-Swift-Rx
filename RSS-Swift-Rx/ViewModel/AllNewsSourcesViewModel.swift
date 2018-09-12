//
//  AllNewsSourcesViewModel.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 26.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import RxSwift
import RxCocoa

class AllNewsSourcesViewModel: NSObject {
    
    public func fetchAllNewsSourceEntities() -> FRCSectionsSource<NewsSourceEntity>
    {
        let frc = model.obtainAllNewsSourcesFRC()
        return FRCSectionsSource<NewsSourceEntity>(frc: frc)
    }

    private lazy var model = AllNewsSourcesModel()
    private let disposeBag = DisposeBag()

    public private(set) var loading = Variable(false)
    
    public func reloadAllNewsSources() -> AnyObserver<Void> {
        return AnyObserver<Void>(eventHandler: { _ in
            self.loading.value = true
            
            weak var loading = self.loading
            self.model.reloadAllNewsSources().subscribe(
                onError: { (error) in
                    loading?.value = false
            },
                onCompleted: {
                    loading?.value = false
            })
                .disposed(by: self.disposeBag)
        })
    }
}
