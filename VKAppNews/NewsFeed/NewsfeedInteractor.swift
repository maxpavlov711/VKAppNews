//
//  NewsfeedInteractor.swift
//  VKAppNews
//
//  Created by Max Pavlov on 26.03.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?
    
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        
        switch request {
            
        case .getNewsfeed:
            fetcher.getFeed { [weak self] feedResponse in
                self?.feedResponse = feedResponse
                self?.presentFeed()
            }
        case .revealPostIds(postId: let postId):
            revealedPostIds.append(postId)
            presentFeed()
        case .getUser:
            fetcher.getUser { userResponse in
                self.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentUserInfo(user: userResponse))
            }
        }
    }
    
    private func presentFeed() {
        guard let feedResponse = feedResponse else { return }
        presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feedResponse, revealPostIds: revealedPostIds))
    }
}
