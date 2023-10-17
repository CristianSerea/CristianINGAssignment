//
//  Campaign.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import Foundation

struct Campaign: Decodable {
    let attributes: [String]
    var isSelected: Bool = false
    
    var price: String? {
        return attributes.first
    }
    
    var details: [String] {
        return Array(attributes.dropFirst())
    }
}

struct CampaignsRecord: Decodable {
    let record: [Campaign]
    
    enum ContainerKeys: String, CodingKey {
        case record
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        record = try container.decode([[String]].self, forKey: .record).compactMap({ Campaign(attributes: $0) })
    }
}
