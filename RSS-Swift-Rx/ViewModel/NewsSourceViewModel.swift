//
//  NewsSourceViewModel.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 15.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import RxCocoa
import RxSwift

class NewsSourceViewModel: NSObject
{
    public let entity: NewsSourceEntity
    
    init(entity: NewsSourceEntity) {
        self.entity = entity;
    }
    
    public var link: URL {
        return entity.link
    }
    
    public var title: String? {
        return entity.title
    }
    
    public var sourceDescription: String? {
        return entity.sourceDescription
    }
    
    public var imageUrl: URL? {
        return entity.imageUrl
    }
    
    public var imageLink: URL? {
        return entity.imageLink
    }
    
    public var lastBuildDate: Date? {
        return entity.lastBuildDate
    }
    
    private let model = NewsSourceModel()
    private let disposeBag = DisposeBag()
    
    public private(set) var loading = Variable(false)
    
    public func loadNewsSource() -> AnyObserver<Void>
    {
        return AnyObserver<Void>(eventHandler: { _ in
            self.loading.value = true
            self.model.loadNewsSource(url: self.entity.link)
                .subscribe(onError: { (error) in
                    self.loading.value = false
                }, onCompleted: {
                    self.loading.value = false
                }).disposed(by: self.disposeBag)
        })
    }
    
    public func openImageLink()
    {
        if let imageLink = entity.imageLink {
            UIApplication.shared.open(imageLink, options: [:], completionHandler: nil)
        }
    }
    
    public func delete()
    {
        model.deleteNewsSource(url: self.entity.link)
    }
}
