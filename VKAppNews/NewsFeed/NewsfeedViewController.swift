//
//  NewsfeedViewController.swift
//  VKAppNews
//
//  Created by Max Pavlov on 26.03.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedDisplayLogic: class {
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic, NewfeedCodeCellDelegate {
    
    var interactor: NewsfeedBusinessLogic?
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    
    private var feedViewModel = FeedViewModel.init(cells: [], footerTitle: nil)
    
    @IBOutlet weak var table: UITableView!
    private var titleView = TitleView()
    private lazy var footerView =  FooterView()
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsfeedInteractor()
        let presenter             = NewsfeedPresenter()
        let router                = NewsfeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTable()
        setupTopBars()

        view.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsfeed)
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getUser)
    }
    
    private func setupTable() {
        let topInset: CGFloat = 8
        table.contentInset.top = topInset
        table.register(UINib(nibName: "NewsfeedCell", bundle: nil), forCellReuseIdentifier: NewsfeedCell.reuseID)
        table.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)
        
        table.separatorStyle = .none
        table.backgroundColor = .clear
        
        table.addSubview(refreshControl)
        table.tableFooterView = footerView
    }
    
    private func setupTopBars() {
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }
    
    @objc private func refresh() {
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsfeed)
    }
    
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayNewsfeed(feedViewModel: let feedViewModel):
            self.feedViewModel = feedViewModel
            footerView.setTitle(feedViewModel.footerTitle)
            table.reloadData()
            refreshControl.endRefreshing()
        case .displayUser(userViewModel: let userViewModel):
            titleView.set(userViewModel: userViewModel)
        case .dispayFooterLoader:
            footerView.showLoader()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNextBatch)
        }
    }
    
    // MARK: - NewfeedCodeCellDelegate
    func revealPost(for cell: NewsfeedCodeCell) {
        guard let indexPath = table.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        
        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.revealPostIds(postId: cellViewModel.postId))
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseID, for: indexPath) as! NewsfeedCell
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCodeCell.reuseId, for: indexPath) as! NewsfeedCodeCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
}
