//
//  CollectionTableViewCellViewModel.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import Foundation

struct CollectionTableViewModel {
    let viewModels: [TileCollectionViewCellViewModel]
}

protocol CollectionTableViewCellDelegate: AnyObject {
    func didTapItem(with viewModel: TileCollectionViewCellViewModel)
}

/// Storyboard identifiers the home tiles navigate to.
///
/// Kept as constants so a tile cannot point at a scene whose identifier was
/// renamed, and so the "not built yet" state is explicit rather than a crash.
enum StoryboardDestination {
    static let characters = "Characters"
    static let organizations = "Organizations"
    static let itemsAndConcepts = "Items&Concepts"
    static let developers = "Developers"
    static let welcome = "Welcome"
}
