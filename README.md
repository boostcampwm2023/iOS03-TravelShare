# ✈️ 어디갈래 - iOS03 
여행을 나눔으로 새로운 여행을 만들어보세요✈️

## ✍🏻 서비스 소개
- **여행 공유 플랫폼**
- **다른 여행자의 여행을 참고해서 편하게 자신만의 여행 계획을 세워보세요.**
- **계획한 여행을 기록하고 공유하세요.**

<p align="center">  
  <img src="https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/9d07533e-2e65-43f4-b8b7-175849512125" align="center" width="24%">  
  <img src="https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/2c4c60f9-918a-46d5-976b-a84fdff20c16" align="center" width="24%">  
  <img src="https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/759f09ba-86b1-420a-a54d-99058a7533da" align="center" width="24%">  
  <img src="https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/32c51384-6232-4dc1-98cf-c46b42c4686a" align="center" width="24%">  
</p>

## 🏞️ 앱 시연 영상

https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/5ca89cf7-9a6e-47da-87b4-6b5c28227b9f

## 🙏 Macro 팀 소개 
|[S002_김경호](https://github.com/ykm989)|[S003_김나훈](https://github.com/KimNahun)|[S017_변진하](https://github.com/Byeonjinha) |[J075_송호선](https://github.com/nossoh98)|[J120_이지훈](https://github.com/jijihuny)|
|:-:|:-:|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/37203016?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/118811606?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/87685946?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/90089657?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/112816117?v=4" width=150>|

## 🏡 팀 페이지

:pushpin: [Notion](https://necessary-grin-f0b.notion.site/ed1785c63de744659485ba8b78125281?pvs=4)


## 📄 팀 문서들


| 앱 기획서 | 백로그 | 기술 스택 |
| -------- | -------- | -------- |
| :pushpin: [앱 기획서](https://necessary-grin-f0b.notion.site/642e106ef6b64b89bfee712a60ac0ffc?pvs=4)     | :pushpin: [백로그](https://necessary-grin-f0b.notion.site/3f99b5aa8e2646a2a446d0278d7c31fa?pvs=4)     | :pushpin: [기술 스택](https://necessary-grin-f0b.notion.site/8b430dba9ae344ec91f87db96135ed72?pvs=4) |

## 🤝 우리의 약속


| 그라운드 룰 | Commit Convention | Issue Convention | PR Convention |
| -------- | -------- | -------- | -------- |
| :pushpin: [그라운드 룰](https://necessary-grin-f0b.notion.site/d45a562d318049d48164335c3e9e562d?pvs=4)     | :pushpin: [Commit Convention](https://necessary-grin-f0b.notion.site/Commit-Convention-b750a1e1db7342edbc2d3956b1841d0e?pvs=4)     | :pushpin: [Issue Convention](https://necessary-grin-f0b.notion.site/Issue-Convention-54d447f4915c4efba9519eba91bab816?pvs=4)     | :pushpin: [PR Convention](https://necessary-grin-f0b.notion.site/PR-Convention-e095863a5dd54b9eba42692dcf61eb19?pvs=4)     |

## 기술 스택
### BE
- MySQL
- redis
- nest.js
- Docker

#### MySQL
- 가장 익숙한 관계형 DB
- 활발한 ORM 지원
- 가장 방대한 자료

#### Redis
- key-value 기반의 간편한 사용
- hash, set, sorted set, json 등 다양한 자료구조 지원
- 메모리 기반의 빠른 속도
- 추후 노릴 수 있는 높은 확장성

#### Nest.js
- Opinionated Web Framework
- 활발한 DI/IOC 지원
- 다양한 wrapping 라이브러리 제공
- 익숙한 express 기반

#### Docker
- 실행 환경에 대한 제약 해소
- 배포 환경과 개발 환경의 통일성 유지 가능
- 손쉬운 초기화와 셋팅

### iOS
- UIKit
- URLSession
- SwiftLint

#### NaverMap API
- 가장 친숙한 UI를 가진 지도
- 지도 정보가 가장 업데이트가 잘 된다 생각함

#### KeyChain
- Login 기능이 들어가 있어서 예민한 개인정보들을 안전한 곳에 보관할 필요가 있음
    
#### Combine
- MVVM 패턴 사용 시 View와 ViewModel을 DataBinding 하기 용이 함

#### Modularization
- 반복적으로 재사용 되는 기능이 존재
- 모듈화를 하면 앱의 유지 보수가 용이

#### Clean Architecture + MVVM
- 추후 앱의 변경이 잦을 수 있음을 고려
- 적용을 한다면 변동성에 강하고, 유지 보수가 용이 함

#### MVVM

- 비즈니스 로직 중심으로 배치하기 때문에 클린 아키텍쳐와 의존성 역전 원칙을 가장 존중하기 좋은 패턴이라 생각
- 적은 시간에 개발을 마쳐야 하기 때문에 MVP, VIPER 보다는 익숙한 패턴임으로 선택

## 만들면서 했던 고민Log

- [enum vs struct](https://www.notion.so/enum-vs-struct-8284b6b95d6a4dac947f37fb72d1ecf8?pvs=4)
- [글 로딩 속도가 느려요](https://www.notion.so/08de732c0fe94869a0c274512fd60467?pvs=4)
- [CoreData Pin 정보 변경](https://www.notion.so/CoreData-Pin-e3c617cc3faa4efa88b4b7d067ea641d?pvs=4)
- [글 상세 페이지 좋아요 처리](https://www.notion.so/0427152692b7488b93e928af2686b441?pvs=4)
- [비동기시 이미지를 매핑 하는 방법](https://www.notion.so/cd4ebe03e9a04e2490a0ae7626d13d39?pvs=4)

이 외에도 Macro 팀의 [고민Log](https://www.notion.so/Log-ce0c7e4f23024c6d809983ec249b02f1) 구경해보세요
