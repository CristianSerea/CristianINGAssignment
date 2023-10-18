//
//  AttributeView.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 17.10.2023.
//

import UIKit

class AttributeView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNibView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNibView()
    }
}

extension AttributeView {
    private func setupNibView() {
        guard let nibView = nibView else {
            return
        }
        
        addSubview(nibView)
    }
}

extension AttributeView {
    func setupContent(title: String) {
        titleLabel.text = title
    }
}
