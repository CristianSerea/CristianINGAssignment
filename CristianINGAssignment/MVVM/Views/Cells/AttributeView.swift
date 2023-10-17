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
        
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension AttributeView {
    private func setupView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AttributeView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.frame = bounds
        addSubview(view)
    }
}

extension AttributeView {
    func setupContent(title: String) {
        titleLabel.text = title
    }
}
