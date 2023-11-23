//
//  MyPageViewController.swift
//  Macro
//
//  Created by Byeon jinha on 11/21/23.
//

import UIKit

final class MyPageViewController: TabViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    private let viewModel: MyPageViewModel
    
    // MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "아몰랑"
        label.textColor = UIColor.appColor(.purple5)
        label.font = UIFont.appFont(.baeEunBody)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    // MARK: - Init
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
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
    }
    
}

// MARK: - UI Settings

extension MyPageViewController {
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubviews() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(tableView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: Metrics.imageWidth),
            profileImageView.heightAnchor.constraint(equalToConstant: Metrics.imageHeight),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Padding.imageTop),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: Metrics.nameLabelWidth),
            nameLabel.heightAnchor.constraint(equalToConstant: Metrics.nameLabelHeight),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: Padding.labelTop),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Padding.tableViewTop),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Padding.tableViewSide),
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
    
}

// MARK: - Methods

extension MyPageViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel.information.count
        case 1: return viewModel.post.count
        default: return viewModel.management.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTableViewCell", for: indexPath)
        cell.backgroundColor = UIColor.appColor(.purple1)
        
        switch indexPath.section {
        case 0: cell.textLabel?.text = "\(viewModel.information[indexPath.row])"
        case 1: cell.textLabel?.text = "\(viewModel.post[indexPath.row])"
        default: cell.textLabel?.text = "\(viewModel.management[indexPath.row])"
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
}

// MARK: - LayoutMetrics

extension MyPageViewController {
    enum Metrics {
        static let imageWidth: CGFloat = 120
        static let imageHeight: CGFloat = 120
        static let nameLabelWidth: CGFloat = 42
        static let nameLabelHeight: CGFloat = 46
    }
    
    enum Padding {
        static let imageTop: CGFloat = 40
        static let labelTop: CGFloat = 20
        static let tableViewTop: CGFloat = 10
        static let tableViewSide: CGFloat = 38
        static let tableViewBottom: CGFloat = 75
    }
}
