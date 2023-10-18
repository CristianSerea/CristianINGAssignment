//
//  GlobalConstants.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import Foundation

struct GlobalConstants {
    struct Server {
        static let domain = "https://api.jsonbin.io/v3/b/"
        static let specifics = "652922f70574da7622b858cd"
        static let channels = "6529350c12a5d376598b363b"
    }
    
    struct Layout {
        static let marginOffset: CGFloat = 20
    }
    
    struct Identifier {
        static let cell = "cell"
        static let placeholderCell = "placeholderCell"
        static let campaignCell = "campaignCell"
        static let placeholderTableViewCell = "PlaceholderTableViewCell"
        static let campaignCollectionViewCell = "CampaignCollectionViewCell"
    }
    
    struct Data {
        static let email = "bogus@bogus.com"
    }
}
