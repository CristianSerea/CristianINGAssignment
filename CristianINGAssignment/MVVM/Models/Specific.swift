//
//  Specific.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import Foundation

struct Specific {
    let name: String
    var isSelected: Bool = false
}

struct SpecificsRecord: Decodable {
    let record: [String]
}
