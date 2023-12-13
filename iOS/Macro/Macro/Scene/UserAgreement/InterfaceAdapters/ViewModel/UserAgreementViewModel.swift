//
//  UserAgreementViewModel.swift
//  Macro
//
//  Created by Byeon jinha on 12/13/23.
//

import Combine
import Foundation

final class UserAgreementViewModel: ViewModelProtocol {
    
    private let outputSubject = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    enum Input {
        case touchAgree(UserAgreement)
        case completeAgree
    }
    
    enum Output {
        case changeButton
        case navigateToHomeView
    }
    
    var totalAgreement = UserAgreementModel(type: .total,
                                            content: "전체 약관 동의",
                                            isCheck: false,
                                            url: nil)
    var serviceAgreement = UserAgreementModel(type: .service,
                                              content: "서비스 이용 약관 (필수)",
                                              isCheck: false,
                                              url: URL(string: "https://necessary-grin-f0b.notion.site/5bf51b57980f4ba7835b56c2759064a4?pvs=4"))
    var personalAgreement = UserAgreementModel(type: .personal,
                                               content: "개인정보 수집 및  이용 동의 (필수)",
                                               isCheck: false,
                                               url: URL(string: "https://necessary-grin-f0b.notion.site/8e1b6ddfed434ed999e76e2051e7486e?pvs=4"))
    
    lazy var agreementArray: [UserAgreementModel] = [totalAgreement, serviceAgreement, personalAgreement]
}

internal extension UserAgreementViewModel {
    
    private func completeAgreement() {
        self.outputSubject.send(.navigateToHomeView)
    }
    
    private func changeAgreement(_ agreement: UserAgreement) {
        switch agreement {
        case .personal:
            self.personalAgreement.isCheck.toggle()
        case .service:
            self.serviceAgreement.isCheck.toggle()
        case .total:
            self.totalAgreement.isCheck.toggle()
        }
        
        isAgreementValidate(agreement)
        
        self.outputSubject.send(.changeButton)
    }
    
    private func isAgreementValidate(_ agreement: UserAgreement) {
        if agreement == .total {
            personalAgreement.isCheck = totalAgreement.isCheck
            serviceAgreement.isCheck = totalAgreement.isCheck
        } else {
            totalAgreement.isCheck = serviceAgreement.isCheck && personalAgreement.isCheck
        }
    }
    
    func transform(with input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] input in
            switch input {
            case let .touchAgree(agreement):
                self?.changeAgreement(agreement)
            case .completeAgree:
                self?.completeAgreement()
            }
        }.store(in: &cancellables)
        
        return outputSubject.eraseToAnyPublisher()
    }
}
