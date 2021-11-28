//
//  MRListCell.swift
//  Shukra
//
//  Created by Sadyojat on 11/11/21.
//

import UIKit

class MRListCell: UICollectionViewCell {
    static let reuseIdentifier = "mr-list-cell-reuse-identifier"
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "questionmark.square")
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator
        return view
    }()
    
    private lazy var chevronView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let rtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        let chevronImageName = rtl ? "chevron.left" : "chevron.right"
        let chevronImage = UIImage(systemName: chevronImageName)
        imageView.image = chevronImage
        imageView.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewHierarchy()
        
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension MRListCell {
    func configureLabel(with text: String) {
        label.text = text
    }
}

extension MRListCell {
    private func configureViewHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(chevronView)
        contentView.addSubview(separatorView)
        
        let inset = 5.0
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 30.0),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            chevronView.widthAnchor.constraint(equalTo: chevronView.heightAnchor),
            chevronView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronView.heightAnchor.constraint(equalToConstant: 15.0),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -inset),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -inset),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset)
        ])
    }
}
