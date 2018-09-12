//
//  NewsViewController.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 25.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class NewsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var disposeBag: DisposeBag?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    public var viewModel: NewsViewModel? {
        willSet {
            self.resetUI()
        }
        didSet (newValue) {
            if (self.isViewLoaded) {
                self.setupUI()
            }
        }
    }
    
    private func setupUI()
    {
//        guard let viewModel = self.viewModel else {
//            return
//        }
//        
//        let disposeBag = DisposeBag()
//        self.disposeBag = disposeBag
        
//        viewModel.title
//            .bind(to: titleLabel.rx.text)
//            .disposed(by: disposeBag)
//        
//        viewModel.newsDescription
//            .bind(to: descriptionTextView.rx.text)
//            .disposed(by: disposeBag)
//        
//        viewModel.pubDate
//            .map { $0 != nil ? DateFormatter.localizedString(from: $0!,
//                                                             dateStyle: .medium,
//                                                             timeStyle: .short) : nil}
//            .bind(to: pubDateLabel.rx.text)
//            .disposed(by: disposeBag)
    }
    
    private func resetUI()
    {
        self.disposeBag = nil;
    }
}
