//
//  TileCollectionViewCellViewModel.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import Foundation
import UIKit

/// One tile on the home screen.
struct TileCollectionViewCellViewModel {
    let title: String
    let backgroundColor: UIColor

    /// Storyboard scene this tile opens.
    ///
    /// `nil` means the destination is not built yet. Those tiles stay visible
    /// but are marked unavailable instead of failing at tap time.
    let destinationIdentifier: String?

    var isAvailable: Bool { destinationIdentifier != nil }

    init(title: String, backgroundColor: UIColor, destinationIdentifier: String? = nil) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.destinationIdentifier = destinationIdentifier
    }
}
