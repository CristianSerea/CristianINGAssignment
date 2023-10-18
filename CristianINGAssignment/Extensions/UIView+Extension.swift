//
//  UIView+Extension.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 18.10.2023.
//

import UIKit

extension UIView {
    var nibView: UIView? {
        let type = type(of: self)
        let bundle = Bundle(for: type)
        let name = String(describing: type)
        let nibName = name.components(separatedBy: ".").last ?? name
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return nil
        }
        
        nibView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        nibView.frame = bounds
        
        return nibView
    }
}
