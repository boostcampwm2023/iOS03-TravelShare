//
//  FollowResultCollectionView.swift
//  Macro
//
//  Created by 김나훈 on 12/5/23.
//

import Foundation
import MacroNetwork
import UIKit

final class FollowResultCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let viewModel: MyPageViewModel
    weak var postDelegate: PostCollectionViewDelegate?
    private let provider = APIProvider(session: URLSession.shared)
    
    init(frame: CGRect, viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(FollowResultCell.self, forCellWithReuseIdentifier: "FollowResultCell")
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.followList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowResultCell", for: indexPath) as? FollowResultCell else {
            return UICollectionViewCell()
        }
        let user = viewModel.followList[indexPath.row]
        cell.configure(with: user)
        cell.delegate = postDelegate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedLocation = viewModel.followList[indexPath.row]
        
        let email = selectedLocation.email
        let userInfoViewModel = UserInfoViewModel(postSearcher: Searcher(provider: provider), followFeature: FollowFeature(provider: provider), patcher: Patcher(provider: provider))
        let userInfoViewController = UserInfoViewController(viewModel: userInfoViewModel, userInfo: email)
        postDelegate?.didTapProfile(viewController: userInfoViewController)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.width - 20, height: 40)
    }
}
