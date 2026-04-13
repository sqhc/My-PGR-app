import UIKit

class OrganizationTableViewCell: UITableViewCell {
    static let identifier = "OrganizationTableViewCell"
    
    private let organizationImageView: UIImageView = {
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
        contentView.addSubview(organizationImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            organizationImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            organizationImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            organizationImageView.widthAnchor.constraint(equalToConstant: 100),
            organizationImageView.heightAnchor.constraint(equalToConstant: 100),
            organizationImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: organizationImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            descriptionTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: organizationImageView.trailingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with organization: Organization) {
        organizationImageView.image = UIImage(named: organization.image)
        nameLabel.text = organization.name
        descriptionTextView.text = getLocalizedDescription(from: organization.description)
    }
    
    private func getLocalizedDescription(from descriptions: [String: String]) -> String {
        let preferredLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? Locale.preferredLanguages.first?.prefix(2) ?? "en"
        return descriptions[String(preferredLanguage)] ?? descriptions["en"] ?? ""
    }
}
