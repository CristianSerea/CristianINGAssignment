//
//  Coordinator.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import UIKit

protocol CoordinatorDelegate {
    func push(viewController: UIViewController?)
    func pop()
}

class Coordinator: CoordinatorDelegate {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    
    private lazy var specificsViewController: SpecificsViewController = getSpecificsViewController()
    private var channelsViewController: ChannelsViewController?
    
    init(withWindow window: UIWindow) {
        self.window = window
    }
    
    func start() {
        navigationController = UINavigationController(rootViewController: specificsViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func push(viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
}

extension Coordinator: SpecificsViewControllerDelegate {
    private func getSpecificsViewController() -> SpecificsViewController {
        let specificsViewController = SpecificsViewController()
        specificsViewController.specificsViewControllerDelegate = self
        specificsViewController.title = "Specifics"
        
        return specificsViewController
    }
    
    func didSelect(specifics: [Specific]) {
        channelsViewController = getChannelsViewController(specifics: specifics)
        push(viewController: channelsViewController)
    }
}

extension Coordinator: ChannelsViewControllerDelegate {
    private func getChannelsViewController(specifics: [Specific]) -> ChannelsViewController {
        let channelsViewController = ChannelsViewController(specifics: specifics)
        channelsViewController.channelsViewControllerDelegate = self
        channelsViewController.title = "Channels"
        
        return channelsViewController
    }
    
    func didSelect(channel: Channel) {
        let campaignsViewController = getCampaignsViewController(channel: channel)
        push(viewController: campaignsViewController)
    }
    
    func goBackAndResetSpecifics() {
        navigationController?.popViewController(animated: true)
        specificsViewController.reset()
    }
}

extension Coordinator: CampaignsViewControllerDelegate {
    private func getCampaignsViewController(channel: Channel) -> CampaignsViewController {
        let campaignsViewController = CampaignsViewController(channel: channel)
        campaignsViewController.campaignsViewControllerDelegate = self
        campaignsViewController.title = "Campaigns"
        
        return campaignsViewController
    }
    
    func didSelect(campaign: Campaign) {
        
    }
    
    func goBackAndResetChannel() {
        navigationController?.popViewController(animated: true)
        channelsViewController?.reset()
    }
}
