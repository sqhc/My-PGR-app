//
//  CollectionTableViewCell.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import UIKit

/// One row of the home screen: a horizontal strip of tiles.
class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /// Ratio applied to a tile's width to get its height.
    private static let tileHeightRatio: CGFloat = 1.1
    /// Tile width as a fraction of the strip's width.
    private static let tileWidthRatio: CGFloat = 2.5

    weak var delegate: CollectionTableViewCellDelegate?

    private var viewModels: [TileCollectionViewCellViewModel] = []

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: TileCollectionViewCell.identifier)
        collection.backgroundColor = .systemBackground
        return collection
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }

    /// Height this row wants for the given width.
    static func height(forWidth width: CGFloat) -> CGFloat {
        let tileWidth = width / tileWidthRatio
        return tileWidth / tileHeightRatio
    }

    func configure(with viewModel: CollectionTableViewModel) {
        viewModels = viewModel.viewModels
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TileCollectionViewCell.identifier,
            for: indexPath
        ) as? TileCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = contentView.frame.size.width / Self.tileWidthRatio
        return CGSize(width: width, height: width / Self.tileHeightRatio)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard viewModels.indices.contains(indexPath.row) else { return }
        delegate?.didTapItem(with: viewModels[indexPath.row])
    }
}
