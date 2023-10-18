//
//  PlaceholderTableViewCell.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 17.10.2023.
//

import UIKit

class PlaceholderTableViewCell: UITableViewCell {
    var placeholderButtonDidTap: (() -> Void)?
    
    @IBOutlet weak var placeholderTitleLabel: UILabel!
    @IBOutlet weak var placeholderSubtitleLabel: UILabel!
    @IBOutlet weak var placeholderButton: UIButton!
}

extension PlaceholderTableViewCell {
    func setupContent(title: String, subtitle: String, buttonTitle: String) {
        placeholderTitleLabel.text = title
        placeholderSubtitleLabel.text = subtitle
        placeholderButton.setTitle(buttonTitle, for: .normal)
    }
}

extension PlaceholderTableViewCell {
    @IBAction func placeholderButtonDidTap(_ sender: Any) {
        placeholderButtonDidTap?()
    }
}
