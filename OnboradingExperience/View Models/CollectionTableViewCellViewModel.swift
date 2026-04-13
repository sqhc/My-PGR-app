//
//  CollectionTableViewCellViewModel.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import Foundation

struct CollectionTableViewModel{
    let viewModels: [TileCollectionViewCellViewModel]
}

protocol CollectionTableViewCellDelegate: AnyObject{
    func DidTapItem(with viewModel: TileCollectionViewCellViewModel)
}
