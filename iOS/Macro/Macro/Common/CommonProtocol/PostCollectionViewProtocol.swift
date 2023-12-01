//
//  PostCollectionViewProtocol.swift
//  Macro
//
//  Created by Byeon jinha on 11/23/23.
//

import Combine
import UIKit

protocol PostCollectionViewProtocol: AnyObject {
    var posts: [PostFindResponse] { get set }
    
    func navigateToProfileView(email: String)
    func navigateToReadView(postId: Int)
    func loadImage(profileImageStringURL: String, completion: @escaping (UIImage?) -> Void)
    func touchLike(postId: Int)
}

extension PostCollectionViewProtocol {
    func loadImage(profileImageStringURL: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: profileImageStringURL) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
