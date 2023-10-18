//
//  Channel.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import Foundation

struct Channel: Decodable {
    let id: String
    let name: String
    let specifics: [Specific]
    var isSelected: Bool = false
    var campaigns: [Campaign]?
    
    var selectedCampaign: Campaign? {
        return campaigns?.first(where: { $0.isSelected })
    }
    
    enum ContainerKeys: String, CodingKey {
        case id
        case name
        case specifics
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        specifics = try container.decode([String].self, forKey: .specifics).compactMap({ Specific(name: $0) })
    }
}

struct ChannelsRecord: Decodable {
    let record: [Channel]
}
