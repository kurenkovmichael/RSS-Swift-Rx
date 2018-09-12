//
//  NewsSourcesViewController.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 15.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

import MagicalRecord

class NewsSourcesViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    
    var dataSource: LazyTableViewDataSource<FRCSectionsSource<NewsSourceEntity>>?
    
    lazy var viewModel = AllNewsSourcesViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = Bundle.main.infoDictionary?["CFBundleName"] as? String
        
        tableView.refreshControl = UIRefreshControl()
        
        if let refreshControl = tableView.refreshControl {
            viewModel.loading.asObservable()
                .bind(to: refreshControl.rx.isRefreshing)
                .disposed(by: disposeBag)
            
            refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
                .subscribe(viewModel.reloadAllNewsSources())
                .disposed(by: disposeBag)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 72
        
        RxKeyboard.instance.frame
            .map({ (frame) -> CGFloat in
                let minY = self.view.convert(frame, from: nil).minY
                return self.view.bounds.height - minY
            }).drive(onNext: { height in
                self.tableView.contentInset.bottom = height
            }).disposed(by: disposeBag)
        
        let newsSourceCellReuseIdentifier = "NewsSourceCell"
        tableView.register(UINib(nibName: String(describing: NewsSourceCell.self), bundle: nil),
                           forCellReuseIdentifier: newsSourceCellReuseIdentifier)
    
        dataSource = LazyTableViewDataSource<FRCSectionsSource<NewsSourceEntity>>(
            source: viewModel.fetchAllNewsSourceEntities(),
            configureCell: { (source, tv, ip) -> UITableViewCell in
                let cell = tv.dequeueReusableCell(withIdentifier: newsSourceCellReuseIdentifier,
                                                  for: ip) as! NewsSourceCell
                
                let vm = NewsSourceViewModel(entity: source.entity(at: ip))
                cell.configure(viewModel: vm)
                
                return cell
        })
        
        dataSource?.didSelect = { (source, tv, ip) in
            tv.deselectRow(at: ip, animated: true)
            
            let vc = NewsSourceViewController(nibName: "NewsSourceViewController", bundle: nil)
            vc.viewModel = NewsSourceViewModel(entity: source.entity(at: ip))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        dataSource?.editActionsForRow = { (source, ip) in
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
                let vm = NewsSourceViewModel(entity: source.entity(at: ip))
                vm.delete()
            }
            delete.backgroundColor = .coral
            return [delete]
        }
        
        dataSource?.canEditRow = { (source, ip) in return true }
        dataSource?.canMoveRow = { (source, ip) in return true }
        dataSource?.tableView = tableView
        
        shyNavBarManager.scrollView = tableView
        
        tableView.tableFooterView = createAddNewsSourceFooter()
    }
    
    @objc private func addButtonDidTapped(_ sender: UIButton)
    {
        let vc = AddNewsSourceViewController(nibName: "AddNewsSourceViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createAddNewsSourceFooter() -> UIView
    {
        let addButton = UIButton.init(type: .custom)
        addButton.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        addButton.tintColor = .darkBlue
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heroID = "addButton";
        
        let footerBackground = UIView(frame: CGRect(x: 0, y: 0, width: 66, height: 66))
        footerBackground.translatesAutoresizingMaskIntoConstraints = false
        footerBackground.layer.cornerRadius = 33
        footerBackground.layer.masksToBounds = true
        footerBackground.layer.borderWidth = 1
        footerBackground.layer.borderColor = UIColor(white: 0, alpha: 0.15).cgColor
        footerBackground.backgroundColor = .white
        footerBackground.heroID = "addBackground";
        
        footerBackground.addSubview(addButton)
        addButton.leadingAnchor.constraint(equalTo: footerBackground.leadingAnchor, constant: 8).isActive = true
        footerBackground.trailingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 8).isActive = true
        addButton.topAnchor.constraint(equalTo: footerBackground.topAnchor, constant: 8).isActive = true
        footerBackground.bottomAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 8).isActive = true
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 92, height: 92))
        footer.backgroundColor = .clear
        
        footer.addSubview(footerBackground)
        footer.centerXAnchor.constraint(equalTo: footerBackground.centerXAnchor).isActive = true
        footer.centerYAnchor.constraint(equalTo: footerBackground.centerYAnchor).isActive = true
        return footer
    }
}
