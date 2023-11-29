//
//  MyPageViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import Combine
import MacroNetwork
import UIKit

final class MyPageViewController: TabViewController {
    
    // MARK: - Properties
    
    private let viewModel: MyPageViewModel
    private let inputSubject: PassthroughSubject<MyPageViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let myPageHeaderView: MyPageHeaderView = MyPageHeaderView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.appColor(.blue1)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Init
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sectionTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        setUpLayout()
        bind()
        if let email = viewModel.email {
            inputSubject.send(.getMyUserData(email))
        }
    }
    
}

// MARK: - UI Settings

extension MyPageViewController {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        myPageHeaderView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        view.addSubview(tableView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.tableViewSide),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.tableViewSide),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Padding.tableViewBottom)
            
        ])
    }
    
}

extension MyPageViewController {
    
    private func setUpLayout() {
        setTranslatesAutoresizingMaskIntoConstraints()
        addsubviews()
        setLayoutConstraints()
    }
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Bind
extension MyPageViewController {
    
    private func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        outputSubject.receive(on: RunLoop.main).sink { [weak self] output in
            switch output {
            case let .sendMyUserData(userProfile):
                self?.updateUserInformation(userProfile)
            default: break
            }
        }.store(in: &cancellables)
    }
    
    private func updateUserInformation(_ userProfile: UserProfile) {
        updateUserProfile(userProfile: userProfile)
    }
    
}

// MARK: - Methods
extension MyPageViewController {
    func updateUserProfile(userProfile: UserProfile) {
        myPageHeaderView.configure(userProfile: userProfile)
    }
}

// MARK: - TableView

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 186
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.information.count
        case 2: return viewModel.post.count
        default: return viewModel.management.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTableViewCell", for: indexPath)
        cell.backgroundColor = UIColor.appColor(.purple1)
        cell.textLabel?.font = UIFont.appFont(.baeEunCallout)
        cell.accessoryType = .disclosureIndicator
        
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            cell.addSubview(myPageHeaderView)
            cell.backgroundColor = UIColor.appColor(.blue1)
            
            NSLayoutConstraint.activate([
                myPageHeaderView.topAnchor.constraint(equalTo: cell.topAnchor),
                myPageHeaderView.heightAnchor.constraint(equalToConstant: 186),
                myPageHeaderView.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
            ])
            
            cell.accessoryType = .none
        case 1: cell.textLabel?.text = "\(viewModel.information[indexPath.row])"
        case 2: cell.textLabel?.text = "\(viewModel.post[indexPath.row])"
        case 3: cell.textLabel?.text = "\(viewModel.management[indexPath.row])"
        default:
            break
        }
        
        let isStartOfSection = indexPath.row == 0
        let numberOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section)
        let isEndOfSection = indexPath.row == numberOfRowsInSection - 1
        
        if isStartOfSection {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.cornerRadius = 10
        } else if isEndOfSection {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 10
        }
        
        if !isEndOfSection {
            let seperateLine: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = UIColor.appColor(.purple2)
                return view
            }()
            
            cell.addSubview(seperateLine)
            NSLayoutConstraint.activate([
                seperateLine.widthAnchor.constraint(equalToConstant: cell.bounds.width - 36),
                seperateLine.heightAnchor.constraint(equalToConstant: 1),
                seperateLine.topAnchor.constraint(equalTo: cell.bottomAnchor),
                seperateLine.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
            ])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section != .zero else { return nil }
        return viewModel.sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != .zero else { return nil }
        let headerLabel = UILabel()
        
        headerLabel.text = viewModel.sections[section]
        headerLabel.font = UIFont.appFont(.baeEunTitle1)
        
        let headerView = UIView()
        
        headerView.backgroundColor = UIColor.appColor(.blue1)
        
        headerView.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.contentView.backgroundColor = UIColor.appColor(.blue1)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 2) {
            let myInfoVC = MyInfoViewController(viewModel: viewModel, selectedIndex: indexPath.row)
            
            if #available(iOS 15.0, *) {
                myInfoVC.sheetPresentationController?.detents = [.large()]
                myInfoVC.sheetPresentationController?.prefersGrabberVisible = true
            }
            present(myInfoVC, animated: true)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            presentImagePickerController()
        } else if indexPath.section == 2 && indexPath.row == 0 {
            guard let email = viewModel.email else { return }
            let provider = APIProvider(session: URLSession.shared)
            let postSearcher = Searcher(provider: provider)
            let followFeature = FollowFeature(provider: provider)
            let userInfoViewModel = UserInfoViewModel(postSearcher: postSearcher, followFeature: followFeature)
            let userInfoViewController = UserInfoViewController(viewModel: userInfoViewModel, userInfo: email)
            navigationController?.pushViewController(userInfoViewController, animated: true)
        } else if indexPath.section == 2 && indexPath.row == 1 {
            inputSubject.send(.completeButtonTapped(3, ""))
        }
    }
}

// MARK: - ImagePicker

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func presentImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    /// 사용자가 이미지를 선택했을 때
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            myPageHeaderView.configure(profileImage: selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /// 사용자가 이미지 선택을 취소했을 때
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Layout Metrics

extension MyPageViewController {
    enum Padding {
        static let tableViewTop: CGFloat = 10
        static let tableViewSide: CGFloat = 38
        static let tableViewBottom: CGFloat = 75
    }
}
