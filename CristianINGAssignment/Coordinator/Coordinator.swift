//
//  Coordinator.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import UIKit

protocol CoordinatorDelegate {
    func push(viewController: UIViewController)
    func pop()
}

class Coordinator: CoordinatorDelegate {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    
    private lazy var specificsViewController: SpecificsViewController = getSpecificsViewController()
    
    init(withWindow window: UIWindow) {
        self.window = window
    }
    
    func start() {
        navigationController = UINavigationController(rootViewController: specificsViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func push(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
}

extension Coordinator: SpecificsViewControllerDelegate {
    private func getSpecificsViewController() -> SpecificsViewController {
        let specificsViewController = SpecificsViewController()
        specificsViewController.title = "Specifics"
        specificsViewController.specificsViewControllerDelegate = self
        
        return specificsViewController
    }
    
    func didSelect(specifics: [Specific]) {
        let channelsViewController = getChannelsViewController(specifics: specifics)
        push(viewController: channelsViewController)
    }
}

extension Coordinator: ChannelsViewControllerDelegate {
    private func getChannelsViewController(specifics: [Specific]) -> ChannelsViewController {
        let channelsViewController = ChannelsViewController(specifics: specifics)
        channelsViewController.title = "Channels"
        channelsViewController.channelsViewControllerDelegate = self
        
        return channelsViewController
    }
    
    func didSelect(channel: Channel) {
        print(channel)
    }
    
    func goBackAndResetSpecifics() {
        navigationController?.popViewController(animated: true)
        specificsViewController.reset()
    }
}
