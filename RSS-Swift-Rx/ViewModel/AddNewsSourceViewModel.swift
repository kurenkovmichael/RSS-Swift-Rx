//
//  AddNewsSourceViewModel.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 15.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import RxCocoa
import RxSwift

class AddNewsSourceViewModel: NSObject
{
    init(model: CreateNewsSourceModel) {
        self.model = model
        self.link = Variable<String?>(self.model.obtainNewNewsSourceLink())
        self.creating = Variable<Bool>(false)
    }
    
    private let model: CreateNewsSourceModel
    private let disposeBag = DisposeBag()
    
    public private(set) var link: Variable<String?> {
        didSet (link) {
            link.asObservable().subscribe(onNext: { (newLink) in
                self.model.storeNewNewsSourceLink(newLink: newLink)
            }).disposed(by: disposeBag)
        }
    }
    
    public private(set) var creating: Variable<Bool>
    
    public var creatingIsAvilible: Observable<Bool> {
        return self.link.asObservable()
            .map { $0 != nil && $0!.count > 0 && $0!.isValidURL() }
    }
    
    public func createNewsSource() -> Observable<Void> {
        guard let linkAsString = self.link.value,
            let link = URL(string: linkAsString) else {
                return Observable<Void>.error(AddNewsSourceError.noLink)
        }
        
        self.creating.value = true
        return self.model.createNewsSource(link: link).do(onError: { (error) in
            self.creating.value = false
        }, onCompleted: {
            self.link.value = nil
            self.creating.value = false
        })
    }
    
    public func fetchNewsSourceEntities() -> FRCSectionsSource<NewsSourceEntity>
    {
        let frc = model.obtainNewsSourcesFRC(searchTerm: link.value)
        return FRCSectionsSource<NewsSourceEntity>(frc: frc)
    }
}
