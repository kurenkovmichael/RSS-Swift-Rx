//
//  AddNewsSourceViewController.swift
//  RSS-Swift-Rx
//
//  Created by Михаил Куренков on 16.12.2017.
//  Copyright © 2017 Михаил Куренков. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

class AddNewsSourceViewController: UIViewController {

    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var keyboardBack: UIView!
    @IBOutlet weak var keyboardBackHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sourceTextField:   UITextField!
    @IBOutlet weak var addButton:         UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var dataSource: LazyTableViewDataSource<FRCSectionsSource<NewsSourceEntity>>?
    
    lazy var viewModel = AddNewsSourceViewModel(model: CreateNewsSourceModel())

    private var disposeBag = DisposeBag()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 72
        
        tableView.register(UINib(nibName: String(describing: NewsSourceCell.self), bundle: nil),
                           forCellReuseIdentifier: newsSourceCellReuseIdentifier)
        
        visualEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)

        updateContent()
        
        Observable.combineLatest(viewModel.creating.asObservable(),
                                 viewModel.creatingIsAvilible)
            .map { (creating, avilible) -> Bool in !creating && avilible }
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.creating.asObservable()
            .map { !$0 }
            .bind(to: sourceTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.creating.asObservable()
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.link.asObservable()
            .bind(to: sourceTextField.rx.text)
            .disposed(by: disposeBag)
        
        sourceTextField.rx.text
            .bind(to: viewModel.link)
            .disposed(by: disposeBag)
        
        addButton.rx.tap.subscribe(onNext: { () in
            self.viewModel.createNewsSource().subscribe(onError: { (error) in
                print(error)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }, onCompleted: {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        viewModel.link.asObservable().subscribe(onNext: { link in
            let hideBlur = (link?.count ?? 0) > 0
            let needShowBlur = !hideBlur && self.visualEffectView.effect == nil
            let needHideBlur = hideBlur  && self.visualEffectView.effect != nil
            if (needHideBlur) {
                self.updateContent()
                UIView.animate(withDuration: 0.5, animations: {
                    self.visualEffectView.effect = nil
                })
            } else if (needShowBlur) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.visualEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
                }, completion: { (f) in
                    self.updateContent()
                })
            }
        }).disposed(by: disposeBag)
        
        let willChangeKeyboardFrame = NotificationCenter.default.rx.notification(.UIKeyboardWillChangeFrame)
            .map { notification -> (CGRect, Double) in
                let rectValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
                let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
                return (rectValue?.cgRectValue ?? CGRect.zero, duration?.doubleValue ?? 0)
        }
        let willChangeFrame = self.view.rx.observe(CGRect.self, "frame")
            .map { (vf) -> CGRect in vf != nil ? self.view.convert(vf!, from: nil) : CGRect.zero }
        
        Observable.combineLatest(willChangeKeyboardFrame, willChangeFrame).map
            { (arg0, vf) -> (CGFloat, Double) in
                let (kf, d) = arg0
                return (vf.height - kf.minY, d)
            }.subscribe(onNext: { (height, d) in
                var contentInset = self.tableView.contentInset
                contentInset.bottom = max(height, 0) + 72
                self.tableView.contentInset = contentInset
                
                if (self.viewAppeared) {
                    self.keyboardBackHeightConstraint.constant = height
                    if (d > 0) {
                        UIView.animate(withDuration: d, animations: {
                            self.view.layoutIfNeeded()
                        })
                    }
                }
            }).disposed(by: disposeBag)
        
        shyNavBarManager.scrollView = tableView
    }

    private var viewAppeared = false
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        viewAppeared = true
        sourceTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        viewAppeared = false
    }
    
    private let newsSourceCellReuseIdentifier = "NewsSourceCell"
    
    private func updateContent()
    {
        let source = self.viewModel.fetchNewsSourceEntities()
        dataSource = LazyTableViewDataSource<FRCSectionsSource<NewsSourceEntity>>(
            source: source,
            configureCell: { (source, tv, ip) -> UITableViewCell in
                let cell = tv.dequeueReusableCell(withIdentifier: self.newsSourceCellReuseIdentifier,
                                                  for: ip) as! NewsSourceCell
                
                let vm = NewsSourceViewModel(entity: source.entity(at: ip))
                cell.configure(viewModel: vm)
                
                return cell
        })
        
//        dataSource?.didSelect = { (source, tv, ip) in
//            tv.deselectRow(at: ip, animated: true)
//
//            let vc = NewsSourceViewController(nibName: "NewsSourceViewController", bundle: nil)
//            vc.viewModel = NewsSourceViewModel(entity: source.entity(at: ip))
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
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
    }
}
