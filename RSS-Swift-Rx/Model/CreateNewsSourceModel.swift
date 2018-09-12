//
//  CreateNewsSourceModel.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 15.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import RxCocoa
import RxSwift
import MagicalRecord

class CreateNewsSourceModel: NSObject {
    
    private let newsSourceModel = NewsSourceModel()
    
    static private let linkKey = "link";
    private var _link: String?
    
    func obtainNewNewsSourceLink() -> String?
    {
        if (_link == nil) {
            _link = UserDefaults.standard.string(forKey: CreateNewsSourceModel.linkKey)
        }
        return _link
    }
    
    func storeNewNewsSourceLink(newLink: String?)
    {
        _link = newLink
        
        DispatchQueue.global().async {
            if let link = self._link {
                UserDefaults.standard.set(link, forKey: CreateNewsSourceModel.linkKey)
            } else {
                UserDefaults.standard.removeObject(forKey: CreateNewsSourceModel.linkKey)
            }
        }
    }
    
    public func obtainNewsSourcesFRC(searchTerm: String?) -> NSFetchedResultsController<NewsSourceEntity>
    {
        
        var predicate: NSPredicate? = nil
        if (searchTerm != nil && searchTerm!.count > 0) {
            predicate = NSPredicate(format: "searchTerm CONTAINS %@", searchTerm!)
        } else {
            predicate = NSPredicate(value: false)
        }
        return NewsSourceEntity.mr_fetchAllSorted(by: "order", ascending: true, with: predicate, groupBy: nil, delegate: nil) as! NSFetchedResultsController<NewsSourceEntity>
    }
    
    public func createNewsSource(link: URL) -> Observable<Void> {
        return createNewsSourceEntity(link: link, title: link.absoluteString)
            .concat(self.newsSourceModel.loadNewsSource(url: link))
    }
    
    private func createNewsSourceEntity(link: URL, title: String) -> Observable<Void>
    {
        return Observable<Void>.create { observer in
            
            var exsitsNewsSource = false
            MagicalRecord.save({ (context) in
                
                let cp = NSPredicate(format: "linkString = %@", link.absoluteString)
                let countOfEntities = NewsSourceEntity.mr_countOfEntities(with: cp, in: context)
                if (countOfEntities > 0) {
                    exsitsNewsSource = true
                    return;
                }
               
                let order = self.obtainMaxOrder(context: context!) ?? 0
                
                let newsSourceEntity = NewsSourceEntity.mr_create(in: context) as! NewsSourceEntity
                newsSourceEntity.link = link
                newsSourceEntity.title = link.absoluteString
                newsSourceEntity.searchTerm = link.absoluteString
                newsSourceEntity.order = order + 1 as NSNumber
                
            }, completion: { (success, error) in
                if exsitsNewsSource {
                    observer.on(.error(AddNewsSourceError.newsSourceExists))
                } else if success {
                    observer.on(.completed)
                } else {
                    observer.on(.error(error ?? AddNewsSourceError.unknownError))
                }
            })
            
            return Disposables.create()
        }
    }
    
    private func obtainMaxOrder(context: NSManagedObjectContext) -> Int64?
    {
        
        guard let fr = NewsSourceEntity.mr_requestAll() else {
            return nil
        }
        
        let keypathExpression = NSExpression(forKeyPath: "order")
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keypathExpression])
        
        let key = "order"
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = key
        expressionDescription.expression = maxExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        fr.resultType = NSFetchRequestResultType.dictionaryResultType
        fr.propertiesToFetch = [expressionDescription]
        
        do {
            if let result = try context.fetch(fr) as? [[String: Int64]],
                let dict = result.first
            {
                return dict[key]
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
}
