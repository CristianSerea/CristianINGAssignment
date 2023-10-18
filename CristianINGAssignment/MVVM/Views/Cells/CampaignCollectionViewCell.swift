//
//  CampaignCollectionViewCell.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 17.10.2023.
//

import UIKit

class CampaignCollectionViewCell: UICollectionViewCell {    
    @IBOutlet weak var campaignView: CampaignView!
}

extension CampaignCollectionViewCell {
    func setupContent(campaign: Campaign?) {
        campaignView.setupContent(campaign: campaign)
    }
}
