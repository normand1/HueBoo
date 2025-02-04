//
//  RootCollectionView.swift
//  HueBoo
//
//  Created by Wikipedia Brown on 9/15/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import UIKit

protocol RootCollectionViewListening: class {
    func onTap()
    func onDisplayCell(at indexPath: IndexPath) -> ColorSet?
    func onDisplayCount() -> Int?
    func onPage(at index: Int)
}

class RootCollectionView: UICollectionView {
    
    weak var listener: RootCollectionViewListening?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = Constants.CGSizes.screenSize
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumLineSpacing = 0
        super.init(frame: .zero, collectionViewLayout: layout)
        dataSource = self
        delegate = self
        isPagingEnabled = true
        register(RootCell.self, forCellWithReuseIdentifier: RootCell.description())
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func insertItem(at indexPath: IndexPath) {
        reloadData()
        scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
}

extension RootCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listener?.onDisplayCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: RootCell.description(), for: indexPath)
    }
    
}

extension RootCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        switch cell {
        case let cell as RootCell:
            let colorSet = listener?.onDisplayCell(at: indexPath)
            cell.tag = indexPath.item
            cell.listener = self
            cell.updateColor(with: colorSet)
        default:
            break
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width
        guard currentIndex == floor(currentIndex) else { return }
        
        listener?.onPage(at: Int(currentIndex))
        
    }
    
}

extension RootCollectionView: RootCellListener {
    
    func onTap(at indexPath: IndexPath) {
        listener?.onTap()
    }
    
}
