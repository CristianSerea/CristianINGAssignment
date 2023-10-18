//
//  SpecificsViewController.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 18.10.2023.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD
import MessageUI

protocol CampaignReviewViewControllerDelegate {
    func emailDidSend()
}

class CampaignReviewViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var campaignView: CampaignView!
    @IBOutlet weak var continueButton: UIButton!
    
    var campaignReviewViewControllerDelegate: CampaignReviewViewControllerDelegate?
    
    private var channel: Channel?
    private let disposeBag = DisposeBag()
    
    init(channel: Channel) {
        self.channel = channel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitleLabel()
        setupCampaignView()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = LocalizableConstants.campaignReviewSendEmailTitle
    }
    
    private func setupCampaignView() {
        campaignView.setupContent(campaign: channel?.selectedCampaign)
        campaignView.selectCampaignButton.removeFromSuperview()
    }
}

extension CampaignReviewViewController {
    @IBAction func continueButtonDidTap(_ sender: Any) {
        sendEmail()
    }
}

extension CampaignReviewViewController: MFMailComposeViewControllerDelegate {
    private func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            return cannotSendMail()
        }

        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([GlobalConstants.Data.email])
        mailComposer.setSubject(LocalizableConstants.campaignReviewEmailSubjectTitle)
        
        if let channel = channel,
            let price = channel.selectedCampaign?.price {
            var body = "\(LocalizableConstants.campaignReviewChannelNameTitle): \(channel.name)"
            body += "\n\n\(LocalizableConstants.campaignReviewMonthlyFeeTitle): \(price)"
            body += "\n\(LocalizableConstants.campaignReviewDetailsTitle):"
            channel.selectedCampaign?.details.forEach({ attribute in
                body += "\n• \(attribute)"
            })
            mailComposer.setMessageBody(body, isHTML: false)
        }
        
        present(mailComposer, animated: true)
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: { [weak self] in
            if let error = error {
                self?.showAlertController(error: error)
            } else {
                self?.campaignReviewViewControllerDelegate?.emailDidSend()
            }
        })
    }
    
    private func cannotSendMail() {
        showAlertController(message: LocalizableConstants.campaignReviewEmailNotAvailableTitle)
    }
}
