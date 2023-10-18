//
//  CampaignView.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 18.10.2023.
//

import UIKit

class CampaignView: UIView {
    var selectCampaignButtonDidTap: ((Campaign?) -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var selectCampaignButton: UIButton!
    
    private var campaign: Campaign?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNibView()
        setupSelectCampaignButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNibView()
        setupSelectCampaignButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 12
        clipsToBounds = true
    }
}

extension CampaignView {
    private func setupNibView() {
        guard let nibView = nibView else {
            return
        }
        
        addSubview(nibView)
    }
    
    private func setupSelectCampaignButton() {
        selectCampaignButton.setTitle(LocalizableConstants.selectButtonTitle, for: .normal)
    }
}

extension CampaignView {
    func setupContent(campaign: Campaign?) {
        self.campaign = campaign
        
        titleLabel.text = campaign?.price
        
        stackView.arrangedSubviews.forEach({ arrangedSubview in
            arrangedSubview.removeFromSuperview()
        })
        
        campaign?.details.forEach({ attribute in
            let attributeView = AttributeView()
            attributeView.setupContent(title: attribute)
            stackView.addArrangedSubview(attributeView)
        })
    }
}

extension CampaignView {
    @IBAction func selectCampaignButtonDidTap(_ sender: Any) {
        selectCampaignButtonDidTap?(campaign)
    }
}
