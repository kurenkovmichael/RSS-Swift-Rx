//
//  NewsCell.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 24.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class NewsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private(set) var viewModel: NewsViewModel?
    
    func configure(viewModel: NewsViewModel, isCompact: Bool) {
        reset()
        
        self.viewModel = viewModel
        
        titleLabel.text  = viewModel.title
        authorLabel.text = viewModel.author
        
        descriptionLabel.numberOfLines = isCompact ? 3 : 0
        descriptionLabel.font = UIFont.systemFont(ofSize: isCompact ? 14 : 18, weight: .thin)
        
        if let newsDescription = viewModel.newsDescription {
//            let data = newsDescription.data(using: String.Encoding.unicode) {
//            do {
//                let text = try NSAttributedString(data: data,
//                                                  options: [ NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html ],
//                                                  documentAttributes: nil).mutableCopy() as! NSMutableAttributedString
//                text.addAttributes([ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin),
//                                     NSAttributedStringKey.foregroundColor : UIColor.black ],
//                                   range: NSRange(location: 0, length: text.length))
//                descriptionLabel.attributedText = text
//            } catch {
                descriptionLabel.text = newsDescription
//            }
        } else {
            descriptionLabel.attributedText = nil
            descriptionLabel.text = nil
        }
        
        if let pubDate = viewModel.pubDate {
            pubDateLabel.text = DateFormatter.localizedString(from: pubDate,
                                                              dateStyle: .medium,
                                                              timeStyle: .short)
        } else {
            pubDateLabel.text = nil
        }
        
        self.layoutIfNeeded()
    }
    
    func reset() {
        viewModel = nil;
        
        titleLabel.text       = nil
        descriptionLabel.text = nil
        authorLabel.text      = nil
        pubDateLabel.text     = nil
    }
}
