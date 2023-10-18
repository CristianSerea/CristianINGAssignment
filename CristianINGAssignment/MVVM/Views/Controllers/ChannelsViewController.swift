//
//  ChannelsViewController.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD

enum ChannelCell {
    case channel(Channel)
    case placeholder(String, String, String)
}

protocol ChannelsViewControllerDelegate {
    func goBackAndResetSpecifics()
    func didSelectChannel(channel: Channel)
}

class ChannelsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    var channelsViewControllerDelegate: ChannelsViewControllerDelegate?
    
    private var channelsViewModel: ChannelsViewModel?
    private var specifics: [Specific] = []    
    private let disposeBag = DisposeBag()
    
    init(specifics: [Specific]) {
        self.specifics = specifics
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNavigationItem()
        updateContinueButton()
        registerTableViewCells()
        setupViewModel()
    }
    
    private func updateNavigationItem() {
        if channelsViewModel?.channels.value.first(where: { $0.isSelected }) != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizableConstants.clearButtonTitle,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(reset))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func updateTableView() {
        tableView.separatorStyle = channelsViewModel?.channels.value.count ?? .zero == .zero ? .none : .singleLine
    }
    
    private func updateContinueButton() {
        continueButton.isHidden = channelsViewModel?.channels.value.count ?? .zero == .zero
        continueButton.isEnabled = channelsViewModel?.channels.value.first(where: { $0.isSelected }) != nil
    }
    
    private func registerTableViewCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: GlobalConstants.Identifier.cell)
        
        let nib = UINib(nibName: GlobalConstants.Identifier.placeholderTableViewCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: GlobalConstants.Identifier.placeholderCell)
    }
}

extension ChannelsViewController {
    private func setupViewModel() {
        channelsViewModel = ChannelsViewModel()
        
        channelsViewModel?.channels.asObservable()
            .skip(1)
            .bind { channels in
                DispatchQueue.main.async { [weak self] in
                    ProgressHUD.dismiss()
                    self?.updateTableView()
                    self?.updateContinueButton()
                }
            }
            .disposed(by: disposeBag)
        
        channelsViewModel?.error.asObserver()
            .bind { error in
                ProgressHUD.dismiss()                
                DispatchQueue.main.async { [weak self] in
                    self?.showAlertController(error: error, completion: { [weak self] in
                        self?.fetchData()
                    })
                }
            }
            .disposed(by: disposeBag)
        
        setupTableView()
        fetchData()
    }
    
    private func fetchData() {
        ProgressHUD.animate(LocalizableConstants.fetchingChannelsDataTitle)
        channelsViewModel?.fetchData(specifics: specifics)
    }
}

extension ChannelsViewController {
    private func setupTableView() {
        channelsViewModel?.channels
            .skip(1)
            .map { channels -> [ChannelCell] in
                if channels.isEmpty {
                    return [.placeholder(LocalizableConstants.channelsPlaceholderTitle,
                                         LocalizableConstants.channelsPlaceholderSubtitle,
                                         LocalizableConstants.resetButtonTitle)]
                } else {
                    return channels.map { ChannelCell.channel($0) }
                }
            }
            .bind(to: tableView.rx.items) { (tableView, row, item) in
                let indexPath = IndexPath(row: row, section: .zero)
                
                switch item {
                case .channel(let channel):
                    let cell = tableView.dequeueReusableCell(withIdentifier: GlobalConstants.Identifier.cell, for: indexPath)
                    cell.textLabel?.text = channel.name
                    cell.accessoryType = channel.isSelected ? .checkmark : .none
                    
                    return cell
                case .placeholder(let title, let subtitle, let buttonTitle):
                    let cell = tableView.dequeueReusableCell(withIdentifier: GlobalConstants.Identifier.placeholderCell, for: indexPath) as! PlaceholderTableViewCell
                    cell.setupContent(title: title, subtitle: subtitle, buttonTitle: buttonTitle)
                    cell.placeholderButtonDidTap = { [weak self] in
                        self?.channelsViewControllerDelegate?.goBackAndResetSpecifics()
                    }
                    
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let weakSelf = self else { 
                    return
                }
                
                guard var channels = weakSelf.channelsViewModel?.channels.value else {
                    return
                }
                
                guard channels.count > .zero else {
                    return
                }
                
                if channels[indexPath.row].isSelected {
                    channels[indexPath.row].isSelected = false
                } else {
                    if let index = channels.firstIndex(where: { $0.isSelected }) {
                        channels[index].isSelected.toggle()
                    }
                    channels[indexPath.row].isSelected.toggle()
                }

                weakSelf.channelsViewModel?.channels.accept(channels)
                
                DispatchQueue.main.async { [weak self] in
                    self?.updateNavigationItem()
                    self?.updateContinueButton()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ChannelsViewController {
    @objc func reset() {
        guard var channels = channelsViewModel?.channels.value else {
            return
        }
        
        if let index = channels.firstIndex(where: { $0.isSelected }) {
            channels[index].isSelected.toggle()
        }
        
        channelsViewModel?.channels.accept(channels)
        
        DispatchQueue.main.async { [weak self] in
            self?.updateNavigationItem()
            self?.updateContinueButton()
        }
    }
    
    @IBAction func continueButtonDidTap(_ sender: Any) {
        guard let channel = channelsViewModel?.channels.value.first(where: { $0.isSelected }) else { 
            return
        }
        
        channelsViewControllerDelegate?.didSelectChannel(channel: channel)
    }
}
