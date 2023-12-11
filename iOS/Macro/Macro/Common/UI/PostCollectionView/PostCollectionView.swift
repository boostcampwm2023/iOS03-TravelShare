//
//  HomeCollectionView.swift
//  Macro
//
//  Created by Byeon jinha on 11/16/23.
//

import Combine
import UIKit

final class PostCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    let viewModel: PostCollectionViewModel
    private var cancellables = Set<AnyCancellable>()
    weak var postDelegate: PostCollectionViewDelegate?
    var readViewDisappear: PassthroughSubject<ReadPost, Never> = .init()
    private let inputSubject: PassthroughSubject<PostCollectionViewModel.Input, Never> = .init()
    private let postRefreshControl: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Initialization
    
    init(frame: CGRect, viewModel: PostCollectionViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.appColor(.blue1)
        
        self.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionViewCell")
        
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        self.dataSource = self
        bind()
        initRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Bind

private extension PostCollectionView {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case .updatePostContnet:
                self?.updatePostContent()
            default: break
            }
        }.store(in: &cancellables)
    }
}

// MARK: - Methods

extension PostCollectionView {
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            viewModel.posts = []
            inputSubject.send(.getNextPost(viewModel.posts.count))
            self.viewModel.isLastPost = false
            refresh.endRefreshing()
        }
    }
    
    func initRefreshControl() {
        postRefreshControl.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        postRefreshControl.backgroundColor = UIColor.clear
        self.refreshControl = postRefreshControl
    }
    
    func updatePostContent() {
        self.reloadData()
    }
}

extension PostCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.posts.count - 3 == indexPath.row && !viewModel.isLastPost {
            inputSubject.send(.getNextPost(viewModel.posts.count))
        }
    }
}

// MARK: - UICollectionViewDataSource Delegate

extension PostCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PostCollectionViewCell",
            for: indexPath) as? PostCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.delegate = postDelegate
        cell.readViewDisappear = self.readViewDisappear
        if !viewModel.posts.isEmpty {
            let item = viewModel.posts[indexPath.row]
            cell.configure(item: item, viewModel: viewModel, indexPath: indexPath, readViewDisappear: self.readViewDisappear)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout Delegate

extension PostCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.width - 20, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }
}
