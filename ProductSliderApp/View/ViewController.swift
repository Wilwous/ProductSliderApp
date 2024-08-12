//
//  ViewController.swift
//  ProductSliderApp
//
//  Created by Антон Павлов on 09.08.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let networkManager = NetworkManager()
    private var products: [ProductModel] = []
    private var categories: [Category] = []
    private var selectedCategoryIndex: Int = 0
    private var collectionViewLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - UI Components
    
    private lazy var sliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        view.register(
            ProductCell.self,
            forCellWithReuseIdentifier: "ProductCell"
        )
        
        return view
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CategoryCell.self,
            forCellWithReuseIdentifier: "CategoryCell"
        )
        
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addElements()
        setupConstraints()
        loadData()
    }
    
    // MARK: - Public Methods
    
    func loadData() {
        networkManager.fetchData { [weak self] responseData in
            guard let self = self, let data = responseData, data.status == "Success" else { return }
            
            self.categories = data.categories
            if let firstCategory = data.categories.first {
                self.products = firstCategory.products
            }
            
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
                self.sliderCollectionView.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        if offsetX > 0 {
            collectionViewLeadingConstraint.constant = max(-offsetX, 0)
        } else {
            collectionViewLeadingConstraint.constant = 10
        }
    }
    
    // MARK: - Setup View
    
    private func addElements() {
        [sliderCollectionView,
         categoryCollectionView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        collectionViewLeadingConstraint = sliderCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            collectionViewLeadingConstraint,
            sliderCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sliderCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sliderCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            categoryCollectionView.bottomAnchor.constraint(equalTo: sliderCollectionView.topAnchor, constant: -10),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else {
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CategoryCell",
                for: indexPath
            ) as? CategoryCell else {
                return UICollectionViewCell()
            }
            let category = categories[indexPath.item]
            cell.configure(with: category)
            
            cell.contentView.backgroundColor = .white
            cell.nameLabel.textColor = indexPath.item == selectedCategoryIndex ? .systemCyan : .black
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProductCell",
                for: indexPath
            ) as? ProductCell else {
                return UICollectionViewCell()
            }
            let product = products[indexPath.item]
            cell.configure(with: product)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let category = categories[indexPath.item]
            let textWidth = category.name.size(
                withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            ).width
            return CGSize(width: textWidth + 30, height: 35)
        } else {
            let padding: CGFloat = 10
            let collectionViewSize = collectionView.frame.size.width - padding
            
            return CGSize(width: collectionViewSize / 2, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            selectedCategoryIndex = indexPath.item
            products = categories[selectedCategoryIndex].products
            
            for index in 0..<categories.count {
                let cellIndexPath = IndexPath(item: index, section: 0)
                if let cell = collectionView.cellForItem(at: cellIndexPath) as? CategoryCell {
                    cell.isSelected = (index == selectedCategoryIndex)
                }
            }
            
            collectionView.reloadData()
            sliderCollectionView.reloadData()
            
            if products.count > 0 {
                sliderCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            }
        }
    }
}
