//
//  NewsSourceCell.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 15.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import UIKit

import Kingfisher

class NewsSourceCell: UITableViewCell
{    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastBuildDateLabel: UILabel!
    
    @IBOutlet weak var iconImageView: ImageView!
    
    private var iconTapRecognizer: UITapGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let iconTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconDidTap))
        self.iconTapRecognizer = iconTapRecognizer
        self.iconImageView.addGestureRecognizer(iconTapRecognizer)
    }

    @objc private func iconDidTap() {
        viewModel?.openImageLink()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private(set) var viewModel: NewsSourceViewModel?
    
    func configure(viewModel: NewsSourceViewModel) {
        reset()
        
        self.viewModel = viewModel
        
        self.contentView.heroID = viewModel.entity.link.absoluteString
        
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.sourceDescription
        
        if let lastBuildDate = viewModel.lastBuildDate {
            lastBuildDateLabel.text = DateFormatter.localizedString(from: lastBuildDate,
                                                                    dateStyle: .medium,
                                                                    timeStyle: .short)
        } else {
            lastBuildDateLabel.text = nil
        }
        
        self.iconImageView.kf.setImage(with: viewModel.imageUrl)
    }
    
    func reset() {
        viewModel = nil
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        lastBuildDateLabel.text = nil
        iconImageView.kf.setImage(with: nil)
    }
}
