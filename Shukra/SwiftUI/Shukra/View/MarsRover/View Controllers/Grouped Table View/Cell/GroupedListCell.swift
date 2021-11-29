//
//  MRListCell.swift
//  Shukra
//
//  Created by Alok Irde on 11/28/21.
//

import UIKit

class GroupedListCell: UICollectionViewCell {
    let textLabel = UILabel()
    let subTextLabel = UILabel()
    let accessoryImageView = UIImageView()
    let separatorView = UIView()
    let contentImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension GroupedListCell {
    
    func configureContent(_ text: String?, _ subText: String?, _ image: UIImage?, _ isLastCell: Bool = false) {
        textLabel.text = text
        subTextLabel.text = subText
        contentImageView.image = image
        separatorView.isHidden = isLastCell
    }
    
    func configure() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .separator
        contentView.addSubview(separatorView)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .preferredFont(forTextStyle: .headline)
        contentView.addSubview(textLabel)
        
        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        subTextLabel.font = .preferredFont(forTextStyle: .caption2)
        contentView.addSubview(subTextLabel)
        
        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let chevronImageName = rtl ? "chevron.left" : "chevron.right"
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        accessoryImageView.image = UIImage(systemName: chevronImageName)
        accessoryImageView.tintColor = .lightGray.withAlphaComponent(0.7)
        contentView.addSubview(accessoryImageView)
        
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        contentImageView.image = UIImage(systemName: "square.and.arrow.down")
        contentImageView.layer.cornerRadius = 5.0
        contentImageView.layer.masksToBounds = true
        
        contentView.addSubview(contentImageView)
        
        let inset = CGFloat(10)
        
        NSLayoutConstraint.activate([
            contentImageView.heightAnchor.constraint(equalToConstant: 44.0),
            contentImageView.widthAnchor.constraint(equalToConstant: 44.0),
            contentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            contentImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: inset),
            contentImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -inset),
            contentImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: contentImageView.trailingAnchor, constant: inset),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            
            subTextLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            subTextLabel.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
            subTextLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: inset),
            subTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
            accessoryImageView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: inset),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 20.0),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 13.0),
            accessoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessoryImageView.topAnchor.constraint(greaterThanOrEqualTo: contentImageView.topAnchor, constant: inset),
            accessoryImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentImageView.bottomAnchor, constant: -inset),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
}
