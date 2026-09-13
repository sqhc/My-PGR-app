import UIKit

class CharacterTableViewCell: UITableViewCell {

    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Rajdhani-Bold", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let elementTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Rajdhani-Regular", size: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let frameTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Rajdhani-Regular", size: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let organizationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Rajdhani-Regular", size: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Rajdhani-Regular", size: 16)
        textView.textColor = .white
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(elementTypeLabel)
        contentView.addSubview(frameTypeLabel)
        contentView.addSubview(organizationLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            characterImageView.widthAnchor.constraint(equalToConstant: 80),
            characterImageView.heightAnchor.constraint(equalToConstant: 80),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            elementTypeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            elementTypeLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),

            frameTypeLabel.topAnchor.constraint(equalTo: elementTypeLabel.bottomAnchor, constant: 2),
            frameTypeLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),

            organizationLabel.topAnchor.constraint(equalTo: frameTypeLabel.bottomAnchor, constant: 2),
            organizationLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),

            descriptionTextView.topAnchor.constraint(equalTo: organizationLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionTextView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with character: Character) {
        characterImageView.image = UIImage.catalogueImage(named: character.image)
        nameLabel.text = character.localizedName
        elementTypeLabel.text = character.localizedElementType
        frameTypeLabel.text = character.localizedFrameType
        organizationLabel.text = character.localizedOrganization
        descriptionTextView.text = character.localizedDescription
    }
}

extension UIImage {
    /// Catalogue art in the current language, or a visible placeholder.
    ///
    /// `image` values come from `GameData.json`, so a value without a matching
    /// imageset is a data problem rather than a programming error: it must show
    /// a placeholder instead of the empty frame this used to render.
    static func catalogueImage(named name: String) -> UIImage? {
        if let image = UIImage(named: name) { return image }
        print("Missing catalogue image asset \"\(name)\"")
        return placeholder
    }

    /// Neutral placeholder drawn at request time, so it needs no asset.
    static let placeholder: UIImage? = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 34, weight: .regular)
        let symbol = UIImage(systemName: "questionmark.square.dashed", withConfiguration: configuration)
        return symbol?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    }()
}
