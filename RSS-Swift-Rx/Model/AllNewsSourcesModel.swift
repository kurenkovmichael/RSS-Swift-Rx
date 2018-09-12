//
//  ReloadAllNewsSourcesModel.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 15.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import RxCocoa
import RxSwift
import MagicalRecord

class AllNewsSourcesModel: NSObject {

    private let newsSourceModel = NewsSourceModel()
    
    public func obtainAllNewsSourcesFRC () -> NSFetchedResultsController<NewsSourceEntity>
    {
           return NewsSourceEntity.mr_fetchAllSorted(by: "order", ascending: true, with: nil, groupBy: nil, delegate: nil) as! NSFetchedResultsController<NewsSourceEntity>
    }
    
    public func reloadAllNewsSources() -> Observable<Void>
    {
        var result = Observable<Void>.empty()
        
        if let newsSourceEntities = NewsSourceEntity.mr_findAll() as! [NewsSourceEntity]? {
            for entity in newsSourceEntities {
                 result = result.concat(self.newsSourceModel.loadNewsSource(url: entity.link))
            }
        }
        return result
    }
}
