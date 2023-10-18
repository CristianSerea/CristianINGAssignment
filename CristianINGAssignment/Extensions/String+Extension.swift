//
//  String+Extension.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 18.10.2023.
//

import UIKit

extension String {
    var localizable: String {
        guard let bundle = getBundle() else {
            return self
        }

        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }

    func getBundle() -> Bundle? {
        guard let path = Bundle.main.path(forResource: "en", ofType: "lproj") else {
            return nil
        }

        return Bundle(path: path)
    }
}
