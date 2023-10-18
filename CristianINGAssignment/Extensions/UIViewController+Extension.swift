//
//  UIViewController+Extension.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 18.10.2023.
//

import UIKit

extension UIViewController {
    func showAlertController(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: LocalizableConstants.errorLabelTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: LocalizableConstants.doneButtonTitle, style: .default, handler: { _ in
            completion?()
        })
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showAlertController(error: Error, completion: (() -> Void)? = nil) {
        showAlertController(message: error.localizedDescription, completion: completion)
    }
}
