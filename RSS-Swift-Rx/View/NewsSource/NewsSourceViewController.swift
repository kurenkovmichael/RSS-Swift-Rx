//
//  NewsSourceViewController.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 24.11.17.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import TLYShyNavBar

import MagicalRecord

import SafariServices

class NewsSourceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var vmDisposeBag: DisposeBag?

    var dataSource: LazyTableViewDataSource<FRCSectionsSource<NewsEntity>>?
    
    private let newsCellReuseIdentifier = "NewsCell"
    
    private var expandedCellIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem?.title = "Back"
        
        shyNavBarManager.scrollView = tableView;
        
        tableView.refreshControl = UIRefreshControl()

        tableView.register(UINib(nibName: String(describing: NewsCell.self), bundle: nil),
                           forCellReuseIdentifier: self.newsCellReuseIdentifier)
        
        setupUI()
    }

    public var viewModel: NewsSourceViewModel? {
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
        guard let viewModel = self.viewModel else {
            return
        }
        
        let disposeBag = DisposeBag()
        vmDisposeBag = disposeBag
        
        self.navigationItem.title = viewModel.title

        self.tableView.heroID = viewModel.link.absoluteString
        
        if let refreshControl = tableView.refreshControl {
            viewModel.loading.asObservable()
                .bind(to: refreshControl.rx.isRefreshing)
                .disposed(by: disposeBag)
            
            refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
                .subscribe(viewModel.loadNewsSource())
                .disposed(by: disposeBag)
        }
        
        let predicate = NSPredicate.init(format: "source = %@", viewModel.entity)
        let frc = NewsEntity.mr_fetchAllSorted(by: "pubDate", ascending: true, with: predicate, groupBy: nil, delegate: nil)
            as! NSFetchedResultsController<NewsEntity>
        
        let dataSource = LazyTableViewDataSource<FRCSectionsSource<NewsEntity>>(
            source: FRCSectionsSource<NewsEntity>(frc: frc),
            configureCell: { (source, tv, ip) in
                let cell = tv.dequeueReusableCell(withIdentifier: self.newsCellReuseIdentifier,
                                                  for: ip) as! NewsCell
                
                let vm = NewsViewModel(entity: source.entity(at: ip))
                cell.configure(viewModel: vm, isCompact: self.isCompactCell(atInexPath: ip))
                
                return cell
        })
        
        dataSource.didSelect = { (source, tv, ip) in
            var ips = [ip]
            if self.isCompactCell(atInexPath: ip) {
                if let oldIp = self.expandedCellIndexPath {
                    ips.append(oldIp)
                }
                self.expandedCellIndexPath = ip
            } else {
                self.expandedCellIndexPath = nil
            }
            tv.deselectRow(at: ip, animated: false)
            tv.reloadRows(at: ips, with: .none)
        }
        
        dataSource.editActionsForRow = { (source, ip) -> [UITableViewRowAction] in
            let newsEntity = source.entity(at: ip);
            if let link = newsEntity.link {
                let open = UITableViewRowAction(style: .destructive, title: "Open") { action, index in
                    self.tableView.setEditing(false, animated: true)
                    
                    let svc = SFSafariViewController(url: link)
                    svc.title = newsEntity.title
                    self.present(svc, animated: true, completion: nil)
                }
                open.backgroundColor = .extraLightBlue
                return [open]
            } else {
                return []
            }
        }
        dataSource.canEditRow = { (source, ip) -> Bool in true }
        
        dataSource.tableView = tableView
        self.dataSource = dataSource
        
        shyNavBarManager.scrollView = tableView
    }
    
    private func resetUI()
    {
        vmDisposeBag = nil
        
        dataSource?.tableView = nil
        dataSource = nil
        
        if (isViewLoaded) {
            tableView.reloadData()
        }
    }
    
    private func isCompactCell(atInexPath indexPath: IndexPath) -> Bool {
        if let expandedCellIndexPath = self.expandedCellIndexPath {
            return expandedCellIndexPath.section != indexPath.section ||
                   expandedCellIndexPath.row != indexPath.row;
        }
        return true;
    }
}
