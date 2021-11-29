//
//  MRDetailViewController.swift
//  Shukra
//
//  Created by Alok Irde on 11/28/21.
//

import UIKit

class MRDetailViewController: UIViewController {
    var scrollView: UIScrollView! = nil
    let imageView = UIImageView()
    let pageTitle = UILabel()
    let imageDescription = UILabel()
    
    var titleString = "Title" {
        didSet {
            pageTitle.text = titleString
        }
    }
    var descriptionString = "Description" {
        didSet {
            imageDescription.text = descriptionString
        }
    }
    var loadImage = UIImage(systemName: "square.and.arrow.down.fill") {
        didSet {
            imageView.contentMode = .scaleAspectFill
            imageView.image = loadImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHierarchy()
        // Do any additional setup after loading the view.
    }
}

//MARK: Configure view hierarchy & layout
extension MRDetailViewController {
    
    func configureHierarchy() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.layer.backgroundColor = UIColor.systemGroupedBackground.cgColor
        imageView.image = loadImage
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.font = .preferredFont(forTextStyle: .title1)
        pageTitle.adjustsFontForContentSizeCategory = true
        pageTitle.text = titleString
        pageTitle.textAlignment = .center
        scrollView.addSubview(pageTitle)
        
        imageDescription.translatesAutoresizingMaskIntoConstraints = false
        imageDescription.font = .preferredFont(forTextStyle: .body)
        imageDescription.text = descriptionString
        imageDescription.numberOfLines = 0
        imageDescription.lineBreakMode = .byWordWrapping
        scrollView.addSubview(imageDescription)
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            // layout page title label
            pageTitle.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor, constant: inset),
            pageTitle.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -inset),
            pageTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            pageTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: inset),
            
            // layout imageview
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -inset),
            imageView.heightAnchor.constraint(equalToConstant: 200.0),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 16/9),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: inset*2),
            
            // layout image description label
            imageDescription.leadingAnchor.constraint(equalTo: scrollView.readableContentGuide.leadingAnchor, constant: inset),
            imageDescription.trailingAnchor.constraint(equalTo: scrollView.readableContentGuide.trailingAnchor, constant: -inset),
            imageDescription.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: inset*2),
            imageDescription.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -inset)
        ])
        
    }
}
