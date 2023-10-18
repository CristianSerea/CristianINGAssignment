//
//  Coordinator.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import UIKit

protocol CoordinatorDelegate {
    func pushViewController(viewController: UIViewController?)
    func popViewController()
    func popToRootViewController()
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
    
    func pushViewController(viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension Coordinator: SpecificsViewControllerDelegate {
    private func getSpecificsViewController() -> SpecificsViewController {
        let specificsViewController = SpecificsViewController()
        specificsViewController.specificsViewControllerDelegate = self
        specificsViewController.title = LocalizableConstants.specificsNavigationItemTitle
        
        return specificsViewController
    }
    
    func didSelectSpecifics(specifics: [Specific]) {
        channelsViewController = getChannelsViewController(specifics: specifics)
        pushViewController(viewController: channelsViewController)
    }
}

extension Coordinator: ChannelsViewControllerDelegate {
    private func getChannelsViewController(specifics: [Specific]) -> ChannelsViewController {
        let channelsViewController = ChannelsViewController(specifics: specifics)
        channelsViewController.channelsViewControllerDelegate = self
        channelsViewController.title = LocalizableConstants.channelsNavigationItemTitle
        
        return channelsViewController
    }
    
    func didSelectChannel(channel: Channel) {
        let campaignsViewController = getCampaignsViewController(channel: channel)
        pushViewController(viewController: campaignsViewController)
    }
    
    func goBackAndResetSpecifics() {
        popViewController()
        specificsViewController.reset()
    }
}

extension Coordinator: CampaignsViewControllerDelegate {
    private func getCampaignsViewController(channel: Channel) -> CampaignsViewController {
        let campaignsViewController = CampaignsViewController(channel: channel)
        campaignsViewController.campaignsViewControllerDelegate = self
        campaignsViewController.title = LocalizableConstants.campaignsNavigationItemTitle
        
        return campaignsViewController
    }
    
    func didSelectCampaign(channel: Channel) {
        let campaignReviewViewController = getCampaignReviewViewController(channel: channel)
        pushViewController(viewController: campaignReviewViewController)
    }
    
    func goBackAndResetChannel() {
        popViewController()
        channelsViewController?.reset()
    }
}

extension Coordinator: CampaignReviewViewControllerDelegate {
    private func getCampaignReviewViewController(channel: Channel) -> CampaignReviewViewController {
        let campaignReviewViewController = CampaignReviewViewController(channel: channel)
        campaignReviewViewController.campaignReviewViewControllerDelegate = self
        campaignReviewViewController.title = LocalizableConstants.campaignNavigationItemTitle
        
        return campaignReviewViewController
    }
    
    func emailDidSend() {
        popToRootViewController()
        specificsViewController.reset()
    }
}
