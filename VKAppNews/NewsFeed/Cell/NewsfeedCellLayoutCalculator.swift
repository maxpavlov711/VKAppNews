//
//  NewsfeedCellLayoutCalculator.swift
//  VKAppNews
//
//  Created by Max Pavlov on 1.04.22.
//

import UIKit

struct Sizes: FeedCellSizes {
    var postImageFrame: CGRect
    var attachmentFrame: CGRect
}

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes {
        return Sizes(postImageFrame: CGRect.zero, attachmentFrame: CGRect.zero)
    }
}
