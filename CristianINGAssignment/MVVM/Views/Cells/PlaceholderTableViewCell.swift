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
}

extension PlaceholderTableViewCell {
    func setupContent(title: String, subtitle: String) {
        placeholderTitleLabel.text = title
        placeholderSubtitleLabel.text = subtitle
    }
}

extension PlaceholderTableViewCell {
    @IBAction func placeholderButton(_ sender: Any) {
        placeholderButtonDidTap?()
    }
}
