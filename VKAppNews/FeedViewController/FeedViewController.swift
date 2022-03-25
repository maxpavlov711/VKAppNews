//
//  FeedViewController.swift
//  VKAppNews
//
//  Created by Max Pavlov on 25.03.22.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        networkService.getFeed()
    }
}
