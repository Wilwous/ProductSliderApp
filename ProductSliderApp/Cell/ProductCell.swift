//
//  ProductCell.swift
//  ProductSliderApp
//
//  Created by Антон Павлов on 10.08.2024.
//

import UIKit
import Kingfisher

final class ProductCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let favoriteIcon = UIImage(named: "icon_heart")?.withRenderingMode(.alwaysTemplate)
        button.setImage(favoriteIcon, for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var addToCartContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        let cartIcon = UIImage(systemName: "basket")?.withRenderingMode(.alwaysTemplate)
        button.setImage(cartIcon, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .customGreen
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 2
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.15).cgColor
        addElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with product: ProductModel) {
        if let price = product.price {
            priceLabel.text = "\(Int(price)) ₽"
        } else {
            priceLabel.text = "Цена не указана"
        }
        
        if let imageUrl = product.detailPicture {
            if let url = URL(string: "https://szorin.vodovoz.ru\(imageUrl)") {
                imageView.kf.setImage(with: url)
            }
        }
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        [imageView,
         priceLabel,
         favoriteButton,
         addToCartContainerView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        addToCartContainerView.addSubview(addToCartButton)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 140),
            
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            addToCartContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            addToCartContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addToCartContainerView.widthAnchor.constraint(equalToConstant: 32),
            addToCartContainerView.heightAnchor.constraint(equalToConstant: 32),
            
            addToCartButton.centerXAnchor.constraint(equalTo: addToCartContainerView.centerXAnchor),
            addToCartButton.centerYAnchor.constraint(equalTo: addToCartContainerView.centerYAnchor),
            addToCartButton.widthAnchor.constraint(equalToConstant: 35),
            addToCartButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}

