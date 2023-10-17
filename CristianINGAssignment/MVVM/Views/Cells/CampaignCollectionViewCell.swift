//
//  CampaignCollectionViewCell.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 17.10.2023.
//

import UIKit

class CampaignCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupMainView()
    }
    
    private func setupMainView() {
        mainView.layer.cornerRadius = 12
        mainView.clipsToBounds = true
    }
}

extension CampaignCollectionViewCell {
    func setupContent(campaign: Campaign?) {
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
