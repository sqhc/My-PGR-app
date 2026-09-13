//
//  TileCollectionViewCell.swift
//  OnboradingExperience
//
//  Created by 沈清昊 on 3/8/23.
//

import UIKit

class TileCollectionViewCell: UICollectionViewCell {

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 6
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.quaternaryLabel.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        alpha = 1
    }

    func configure(with viewModel: TileCollectionViewCellViewModel) {
        contentView.backgroundColor = viewModel.backgroundColor
        label.text = viewModel.title
        // Dimmed tiles have no destination yet; they stay visible so the
        // section is discoverable, but read as not-yet-available.
        alpha = viewModel.isAvailable ? 1 : 0.45
        accessibilityHint = viewModel.isAvailable ? nil : "Coming soon"
    }
}
