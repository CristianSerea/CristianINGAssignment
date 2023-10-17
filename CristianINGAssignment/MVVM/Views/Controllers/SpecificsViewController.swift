//
//  SpecificsViewController.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD

protocol SpecificsViewControllerDelegate {
    func didSelect(specifics: [Specific])
}

class SpecificsViewController: UIViewController {    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    
    var specificsViewControllerDelegate: SpecificsViewControllerDelegate?
    
    private var specificsViewModel: SpecificsViewModel?
    private var specifics: [Specific] = []    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNavigationItem()
        updateContinueButton()
        registerTableViewCell()
        fetchData()
    }
    
    private func updateNavigationItem() {
        if specifics.first(where: { $0.isSelected }) != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(reset))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func updateContinueButton() {
        continueButton.isHidden = specifics.count == .zero
        continueButton.isEnabled = specifics.first(where: { $0.isSelected }) != nil
    }
    
    private func registerTableViewCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension SpecificsViewController {
    private func fetchData() {
        specificsViewModel = SpecificsViewModel()
        
        specificsViewModel?.specifics.asObservable()
            .skip(1)
            .bind { specifics in
                guard specifics.count > .zero else {
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.specifics = specifics      
                    
                    ProgressHUD.dismiss()
                    self?.tableView.reloadData()
                    self?.updateContinueButton()
                }
            }
            .disposed(by: disposeBag)
        
        specificsViewModel?.error.asObserver()
            .bind { error in
                print("111", error)
                ProgressHUD.dismiss()
            }
            .disposed(by: disposeBag)
        
        ProgressHUD.animate("Fetching specifics data")
        
        specificsViewModel?.fetchData()
    }
}

extension SpecificsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specifics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let specific = specifics[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = specific.name
        cell.accessoryType = specific.isSelected ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        specifics[indexPath.row].isSelected.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        updateNavigationItem()
        updateContinueButton()
    }
}

extension SpecificsViewController {
    @objc func reset() {
        for index in specifics.indices {
            specifics[index].isSelected = false
        }
        
        tableView.reloadData()
        updateNavigationItem()
        updateContinueButton()
    }
    
    @IBAction func continueButtonDidTap(_ sender: Any) {
        let specifics = specifics.filter({ $0.isSelected })
        specificsViewControllerDelegate?.didSelect(specifics: specifics)
    }
}
