//
//  Rowlayout.swift
//  VKAppNews
//
//  Created by Max Pavlov on 17.04.22.
//

import UIKit

protocol RowLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize
}

class RowLayout: UICollectionViewLayout {
    
    weak var delegate: RowLayoutDelegate!
    
    fileprivate var numbersOfRows = 1
    
    // константа
    fileprivate var cellPadding: CGFloat = 8
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentWidht: CGFloat = 0
    fileprivate var contentHight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidht, height: contentHight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        
        var photos = [CGSize]()
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoSize = delegate.collectionView(collectionView, photoAtIndexPath: indexPath)
            photos.append(photoSize)
        }
        
        let superviewWidth = collectionView.frame.width
        
        guard let rowHeight = self.rowHeightCounter(superviewWidht: superviewWidth, photosArray: photos) else { return }
    }
    
    private func rowHeightCounter(superviewWidht: CGFloat, photosArray: [CGSize]) -> CGFloat? {
        var rowHeight: CGFloat
        
        let photoWithMinRatio = photosArray.min { first, second in
            (first.height / first.width) < (second.height / second.width)
        }
        
        guard let myPhotoWithMinRatio = photoWithMinRatio else { return nil }
        
        let differents = superviewWidht / myPhotoWithMinRatio.width
        
        rowHeight = myPhotoWithMinRatio.height * differents
        return rowHeight
    }
}
