//
//  SearchResultViewController.swift
//  Macro
//
//  Created by 김나훈 on 11/16/23.
//

import Combine
import MacroNetwork
import UIKit

final class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    private var tableView: UITableView!
    private let viewModel: TravelViewModel
    private let inputSubject: PassthroughSubject<TravelViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        bind()
    }
    
    // MARK: - Init
    
    init(viewModel: TravelViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Settings

extension SearchResultViewController {
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}
// MARK: - Bind
extension SearchResultViewController {
    private func bind() {
        viewModel.transform(with: inputSubject.eraseToAnyPublisher())
            .sink { [weak self] output in
                switch output {
                case .updateSearchResult:
                    self?.tableView.reloadData()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Methods

extension SearchResultViewController {
    
    @objc func pinLocation(_ sender: UIButton) {
        let location = viewModel.searchedResult[sender.tag]
        viewModel.togglePinnedPlaces(location)
        let isPinnedNow = viewModel.isPinned(location)
        let pinImage = isPinnedNow ? UIImage.appImage(.pinFill) : UIImage.appImage(.pin)
        sender.setImage(pinImage, for: .normal)
    }
}

// MARK: - TableView

extension SearchResultViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchedResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           let locationDetail = viewModel.searchedResult[indexPath.row]

           let cellText = "\(locationDetail.placeName)\n\(   locationDetail.addressName)"
           cell.textLabel?.text = cellText
           cell.textLabel?.numberOfLines = 0
           cell.textLabel?.font = UIFont.appFont(.baeEunCallout)
           let pinButton = UIButton(type: .custom)
           let pinImage = viewModel.isPinned(locationDetail) ? UIImage.appImage(.pinFill) : UIImage.appImage(.pin)
           pinButton.setImage(pinImage, for: .normal)
           pinButton.tintColor = UIColor.appColor(.purple4)
           pinButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
           pinButton.addTarget(self, action: #selector(pinLocation(_:)), for: .touchUpInside)
           cell.accessoryView = pinButton
           pinButton.tag = indexPath.row
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let provider = APIProvider(session: URLSession.shared)
        let locationViewModel = LocationInfoViewModel(locationDetail: viewModel.searchedResult[indexPath.row], searcher: Searcher(provider: provider))
        let locationInfoVC = LocationInfoViewController(viewModel: locationViewModel)
        navigationController?.pushViewController(locationInfoVC, animated: true)
    }
}
