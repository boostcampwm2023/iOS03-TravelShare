# ✈️ 어디갈래 - iOS03 

여행을 나눔으로 새로운 여행을 만들어보세요✈️

## ✍🏻 서비스 소개

- **여행 공유 플랫폼**
- **다른 여행자의 여행을 참고해서 편하게 자신만의 여행 계획을 세워보세요.**
- **계획한 여행을 기록하고 공유하세요.**
<p align="center">  
  <img src="https://github.com/boostcampwm2023/iOS03-TravelShare/assets/87685946/7d55273f-cfad-4573-8234-fcc71bc10b00" align="center" width="18%">  
  <img src="https://github.com/boostcampwm2023/iOS03-TravelShare/assets/87685946/42f8136b-d9c7-45d6-96c4-508a144bcdf6" align="center" width="18%">  
  <img src="https://github.com/boostcampwm2023/iOS03-TravelShare/assets/87685946/83ebcb7c-cfc9-4560-acc7-06eb71af5bbd" align="center" width="18%">  
  <img src="https://github.com/boostcampwm2023/iOS03-TravelShare/assets/87685946/37f1e84e-bae8-48f0-a108-f88e7921b470" align="center" width="18%"> 
  <img src="https://github.com/boostcampwm2023/iOS03-TravelShare/assets/87685946/4341d7ae-9dfc-4880-8a08-d6a9098dbf51" align="center" width="18%"> 
</p>

## 우리 앱만의 차이점

- **편의성 증대:** 사용자는 특정 장소에 다녀간 것만 지정해서 Marker로 표시해주고, 그 경로는 앱에서 자동으로 관리해주므로, 여행 후에 경로를 지정해줘야 하는 피로감을 최소화
- **경로의 정확성 및 디테일한 기록:** 사용자가 다녀간 세부 경로를 모두 기억할 필요 없이 이를 관리해주기 때문에 글 작성 시 정확성과 디테일한 부분까지 모두 지정 가능
- **글의 신뢰성 향상:** 사용자가 다녀온 실제 경로를 앱이 관리해주므로, 여행에 대한 글을 작성할 때 실제 여행을 다녀온 것인지 확인이 가능하므로 글에 대한 신뢰성 향상
- **다른 사용자의 여행 계획 참고:** 다른 사람의 실제 여행 경로를 참고하여 자신의 여행 계획 세우기 가능

## 🏞️ 앱 시연 영상

https://github.com/boostcampwm2023/iOS03-TravelShare/assets/118811606/b2eb3944-aa11-4ab3-ac9d-3f2ef63dc076

## 🙏 Macro 팀 소개 

|[S002_김경호](https://github.com/ykm989)|[S003_김나훈](https://github.com/KimNahun)|[S017_변진하](https://github.com/Byeonjinha) |[J075_송호선](https://github.com/nossoh98)|[J120_이지훈](https://github.com/jijihuny)|
|:-:|:-:|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/37203016?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/118811606?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/87685946?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/90089657?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/112816117?v=4" width=150>|

## 📄 팀 문서들

| 앱 기획서 | 백로그 | 기술 스택 |
| -------- | -------- | -------- |
| :pushpin: [앱 기획서](https://necessary-grin-f0b.notion.site/642e106ef6b64b89bfee712a60ac0ffc?pvs=4)     | :pushpin: [백로그](https://github.com/orgs/boostcampwm2023/projects/119)     | :pushpin: [기술 스택](https://necessary-grin-f0b.notion.site/8b430dba9ae344ec91f87db96135ed72?pvs=4) |


## 기술 스택
<details>
    <summary style="font-size: 20px;font-weight: 600;">
        🔙 BE
    </summary>

---

#### MySQL

- **가장 익숙한 관계형 DB**
- **활발한 ORM 지원**
- **가장 방대한 자료**

#### Redis

- **key-value 기반의 간편한 사용**
- **hash, set, sorted set, json 등 다양한 자료구조 지원**
- **메모리 기반의 빠른 속도**
- **추후 노릴 수 있는 높은 확장성**

#### Nest.js

- **Opinionated Web Framework**
- **활발한 DI/IOC 지원**
- **다양한 wrapping 라이브러리 제공**
- **익숙한 express 기반**

#### Docker

- **실행 환경에 대한 제약 해소**
- **배포 환경과 개발 환경의 통일성 유지 가능**
- **손쉬운 초기화와 셋팅**

---

</details>
    
<details>
    <summary style="font-size: 20px;font-weight: 600;">            🍏 iOS
    </summary>

---
    
#### NaverMap API

- **가장 친숙한 UI를 가진 지도**
    - 사용자에게 익숙하고 친숙한 UI를 제공하여 사용자 경험을 향상시킬 수 있습니다.
    - 지도 정보가 직관적이며 업데이트가 잘 되는 것이 사용자에게 중요하다고 생각
- 지도 정보가 가장 업데이트가 잘 된다 생각함

#### KeyChain

- **Login 기능이 들어가 있어서 예민한 개인정보들을 안전한 곳에 보관할 필요가 있음**
    
#### Combine

- **MVVM 패턴 사용 시 View와 ViewModel을 DataBinding 하기 용이 함**
    - 비동기적인 이벤트 스트림을 처리하고 데이터의 변화를 감지하여 UI 업데이트를 쉽게 관리가 가능
    - View와 ViewModel 사이의 데이터 바인딩을 통해 코드의 간결성과 가독성 증가

#### Modularization

- 반복적으로 재사용 되는 기능이 존재
- 모듈화를 하면 앱의 유지 보수가 용이

#### Clean Architecture

- 추후 앱의 변경이 잦을 수 있음을 고려
- 적용을 한다면 변동성에 강하고, 유지 보수가 용이 함

#### MVVM

- 비즈니스 로직 중심으로 배치하기 때문에 클린 아키텍쳐와 의존성 역전 원칙을 가장 존중하기 좋은 패턴이라 생각
- 적은 시간에 개발을 마쳐야 하기 때문에 MVP, VIPER 보다는 익숙한 패턴임으로 선택

---

</details>
    
---
    
# 만났던 Issue Log

---

1. [셀 재사용 및 이미지 로딩 문제 해결 🔄](#셀-재사용-및-이미지-로딩-문제-해결-🔄)
2. [글 로딩 속도 개선 고민과 실행한 해결 방안 🏃‍](#글-로딩-속도-개선-고민과-실행한-해결-방안-🏃‍♂️)
3. [좋아요 클릭 후 데이터 반영에 대한 고민 👍](#좋아요-클릭-후-데이터-반영에-대한-고민-👍)
4. [비동기 이미지 매핑 방법 고민과 해결 방안 📥](#비동기-이미지-매핑-방법-고민과-해결-방안-📥)
5. [위치 정확도 이슈 🛰️](#위치-정확도-이슈-🛰️)
6. [이동 경로의 좌표 수 최적화 🛣️](#이동-경로의-좌표-수-최적화-🛣️)
7. [공간데이터를 어떻게 다룰 것인가? 📊](#공간데이터를-어떻게-다룰-것인가?-📊)
8. [로그를 손쉽게 관리하려면 어떡해야 할까? 🔍](#로그를-손쉽게-관리하려면-어떡해야-할까?-🔍)
9. [어떤 전략으로 캐싱을 해야할까? + 동시성과 일관성의 문제 🗄️](#어떤-전략으로-캐싱을-해야할까?-+-동시성과-일관성의-문제-🗄️)

---

## iOS 

### 셀 재사용 및 이미지 로딩 문제 해결 🔄
<details>
    
---

## 원인
- **비동기 이미지 로딩:** 이미지를 비동기적으로 로드할 때, 네트워크 요청이 완료되기 전에 사용자가 스크롤을 하여 셀이 재사용될 수 있습니다. 이로 인해 이전 셀에 대한 이미지 로드 요청이 새로 재사용된 셀에 영향을 줌
- **이전 상태 유지:** 셀이 재사용될 때 이전 셀의 상태(예: 이미지, 텍스트)가 초기화되지 않아 새 셀에 잘못된 데이터가 표시
    
## 시도했던 방법
**1. 초기화 로직 추가:** ``prepareForReuse`` 메소드를 오버라이드하여 셀이 재사용되기 전에 셀의 상태를 초기화
    - 셀이 재사용 될 때 이전에 설정된 이미지나 텍스트가 남아있게 되며, 새로운 데이터가 로드되기 전까지 잘못된 정보를 보여줄 수 있음
    - 이미지 로딩 같은 비동기 작업이 완료되기 전에 셀이 재사용될 경우, 이전 셀의 이미지 요청 결과가 새 셀에 적용될 수 있음.
    
```swift
override func prepareForReuse() {
    super.prepareForReuse()
    mainImageView.image = nil
    title.text = ""
    summary.text = ""
    postId = nil
}
```
    
-> **개선은 됐지만 완벽한 해결은 못했음.**
- 셀의 뷰 자체는 초기화되지만, 이미 시작된 비동기 이미지 로딩 작업은 계속 진행됨
- 이미지 로딩과 같은 비동기 작업의 결과가 도착했을 때, 해당 결과가 현재 셀의 데이터와 일치하는지 확인하는 로직이 없다면, 여전히 이미지가 표시될 수 있음.
    
**2. 이미지 로딩 로직 변경:** ``prepareForReuse``로 문제를 완전히 해결할 수 없으므로 추가적인 로직이 필요
    - 셀이 이미지 로딩을 요청하고, 로딩 중에 다른 데이터를 표시해야 할 새 셀로 재사용 되었을 때, 이전 이미지 로딩 요청의 결과가 새 셀에 적용될 수 있음.
    - 결과적으로 셀에 잘못된 이미지가 표시되는 문제가 발생

해결 방법
- 각 셀에 이미지 URL을 저장하고, 이미지 로딩이 완료되었을 때 해당 URL이 현재 셀의 URL과 일치하는지 확인
- 일치할 경우에만 이미지를 셀에 설정. 이렇게 하면 재사용된 셀에 대한 잘못된 이미지 설정을 방지할 수 있음
    
## 결론
``prepareForReuse``를 사용한 초기화는 셀의 재사용 시 이전 상태를 리셋하는데 유용하지만, 비동기적으로 로딩되는 데이터(특히 이미지)에 대해서는 완벽한 해결책이 되지 못합니다. 이미지 로딩 로직을 변경하여 로딩 완료 시점에 셀의 현재 상태와 일치하는지 확인하는 추가적인 로직이 필요합니다. 이렇게 함으로써 셀 재사용 시 발생할 수 있는 잘못된 데이터 표시 문제를 효과적으로 해결할 수 있습니다.
    
---
    
</details>

### 글 로딩 속도 개선 고민과 실행한 해결 방안 🏃‍♂️
<details> 

---
    
## 고민거리
홈 화면이 처음 로딩 될 때, 글을 클릭하여 상세 글 페이지로 이동할 때 이미지를 불러오는 속도가 느려 기본 이미지가 먼저 표시되고, 이미지가 뒤늦게 업로드 되는 이슈 발생
    
## 주고 받은 의견들

### 고민했던 해결 방안
1. **인프로그래스 화면 표시하기:** 글 상세 페이지로 이동 시 데이터가 완료될때까지 인프로그래스 화면을 표시하여 사용자에게 로딩 중임을 알릴 수 있도록 고려
2. **이미지 압축:** 이미지를 압축해서 올리기. 원본 이미지보다 낮은 품질의 이미지를 사용하여 업로드 속도를 개선.
3. **URLCache 사용:** 이미지를 중복으로 불러오는 것을 방지하기 위해 URLCache를 활용하여 이미지를 캐싱하고, 네트워크 연결 없이 Cache Memory에서 이미지를 불러올 수 있도록 구현
4. **서버 성능 확대:** 서버의 성능을 확대하여 이미지 업로드 및 전송에 대한 부담을 줄일 수 있는 방안.

    
### 실행한 해결 방안
1. **Image를 압축해서 올리기**
    기존에는 Image를 원본 화질로 올렸지만 현재는 이미지를 0.5 정도로 압축을 해서 올리고 있습니다.
    이미지의 기존 용량은 5~8mb 정도 크기로 꽤 높은 용량이였는데, 현재는 2~4mb 정도로 용량을 낮추면서 이미지 업로드 속도가 육안으로 확인할 수 있을 정도의 퍼포먼스가 있었습니다.
2. **URLCache 사용**
    URLCache를 사용하지 않았을 때는 모든 URL을 조회해서 새로운 데이터를 받아왔습니다.
    이를 Cache를 활용해서 네트워크 연결없이 Cache Memory에서 이미지를 받아오게 해서 서버의 부담도 줄이고, 불러왔던 이미지를 중복되게 불러오는 것을 방지하여 로딩 속도도 개선하였습니다.
    
3. **서버 성능 확대**
    
---
    
</details>

### 좋아요 클릭 후 데이터 반영에 대한 고민 👍
<details>
    
---
    
## 고민 사항
글 상세 페이지에서 좋아요를 클릭한 후에 홈 화면으로 돌아갔을 때, 이 좋아요 클릭이 홈 화면에서 어떻게 반영되어야 할지에 대한 고민
    
## 해결 방안
### 1. home화면 Appear시 API 요청을 통해 데이터 최신화
- 고민한 해결 방안: View가 Load시가 아니라 **Appear**시에 API 요청을 통해 데이터를 최신화 하는 방안
- 문제점
    - Appear 시점에서 API를 호출하면 빈번한 API 요청으로 서버 부하가 커지고, 홈 화면으로 전환 시 앱이 느려보이는 문제가 발생
    - BE 로직으로 인해 홈 화면으로 전환 시 방금 전에 본 게시글의 위치가 변경 되는 이슈 발생
### 2. 해당 **Cell의 Data를 클라이언트에서 수정** 후 이를 Home 화면에 반영
- **고민한 해결 방안**
    - 좋아요 클릭 시 상세 피이지의 데이터를 수정하고, 이를 Home 화면에 반영하는 방식
- **수정 방법**
    - 글 상세 페이지에서 좋아요 클릭 시, 해당 글의 데이터를 수정하고, 이를 홈 화면으로 넘겨서 해당 Cell의 데이터를 업데이트
    - **Disappear** 시점에서 데이터를 업데이트하여 자연스러운 흐름을 유지
- **장점**
    - 로컬에서 작업하므로 속도가 빠르고 앱이 자연스러워 보임
    
---
    
</details>

### 비동기 이미지 매핑 방법 고민과 해결 방안 📥
<details>

--- 

### 문제 도입
우선적으로 이미지를 **Object Storage**에 업로드하고 해당 이미지에 대한 URL을 가져오는 작업을 비동기적으로 처리하면서 이미지와 관련된 다른 정보(마커, 설명 글 등)을 함께 **매핑하는 상황에서 문제가 발생**
    
### 기존 로직
1. 이미지를 Object Storage에 업로드
2. 해당 이미지에 대한 URL을 비동기적으로 가져오기
3. 이미지 URL과 다른 정보를 글에 포함하여 DB에 업로드
    
### 문제점 
이미지를 비동기적으로 가져오기 때문에 이미지 URL이 먼저 도착하는 경우, 이미지와 관련된 다른 정보와 매핑이 뒤섞이는 문제가 발생
    
### 해결 방법
현재 사용 중인 방법은 UIImage 배열과 같은 크기의 배열을 사용하여 **index**값을 활용하여 이미지 URL을 매핑하여 비동기 문제를 해결
그러나 이 방식은 배열의 크기를 이미지의 개수에 맞게 미리 할당해야 하므로 공간을 낭비하는 문제가 있음
추후 개선 예정

---

</details>

### 위치 정확도 이슈 🛰️
<details>
    
---
    
### 문제점
GPS를 사용하여 내 위치를 기록할 때 정확한 위치를 읽어오지 못하고, 가만히 있어도 지속적으로 이동이 기록되는 문제 발생
    
### 해결방안
1. **정확도 설정 재조정**
    - 초기에 발생한 이슈의 원인은 배터리 소모를 줄이기 위해 위치 정확도를 낮춘 것
    - 문제 해결을 위해 원래의 정확도 설정 값인 **KLLocationAccuracyBest**로 복원
    - **KLLocationAccuracyBest**와 **KLLocationAccuracyNearestTenMeters**의 배터리 소모량을 비교하면서 확인 결과 배터리 소모량의 차이가 크지 않아 크리티컬한 문제가 없다고 판단
    
2. **칼만 필터**
    - 피어세션에서 동일한 이슈를 겪은 다른 캠퍼분의 칼만 필터를 적용하여 문제 해결한 케이스가 존재
    - 추후에 칼만 필터를 도입하여 위치 정보의 정확도를 향상시키는 기술적 도전을 계획 중
    
---
    
</details>

### 이동 경로의 좌표 수 최적화 🛣️
<details>
    
---
    
### 문제점
- **CoreLocation**에서 이동 중에 주기적으로 좌표 값을 제공하며, 이로 인해 **이동 경로의 좌표 수가 많은 케이스**가 발생 가능성이 있음
- 좌표 수가 많으면 서버에 저장 및 다른 사용자의 여행 기록을 받아서 화면에 그리는 데 많은 시간이 발생하는 이슈가 존재
    
### 해결방안
1. **좌표 값 최적화를 통한 성능 개선**
    - **CoreLocation**에서 제공하는 모든 좌표 값을 사용하는 것이 아니라, **Timer**를 활용하여 일정 시간마다 최근에 리턴된 좌표를 이어서 사용.
    - **특정 시간(5초)마다 1번씩 좌표**를 사용하는 방식으로 개선
    - 서버에 저장할 때 **과부하를 방지**하고, 지도에 그릴 때 성능 개선 효과를 기대
    
2. **좌표 수 간격 조정**
    - 일정 시간 간격을 조정하여 몇 초마다 1번씩 좌표를 사용할지 팀 내에서 의논
    - 테스트를 통해 최적의 시간 간격을 결정하고, 실제로 5초 주기로 테스트 진행

3. **성능 및 지도 표현 테스트**
    - 각 시간 간격(3초, 5초, 10초, 20초)에 대한 테스트를 수행하여 서버 부하 없이도 성능을 유지하몀ㄴ서 지도에 좌표를 그릴 수 있는 최적의 간격을 찾음
    - 테스트 결과, **5초 주기로 좌표를 사용했을 때, 서버 부하가 적고 지도에 끊김이 없는 것 확인**

4. **좌표 압축**
    - 일직선 경로나, 아니면 많은 양을 압축을 하여 데이터 전송하는 로직을 추후에 기술적 도전으로 계획 중
    
---
    
</details>

---

## BE


### 공간데이터를 어떻게 다룰 것인가? 📊

<details>
    
---
    
저희 앱의 핵심 기능 중 하나는 사용자가 어떤 경로를 통해 여행을 했는지 기록하고 공유하는 것 입니다.

이것은 곧 공간 정보를 
1. 기록하고,
2. 공유하고,
3. 서로의 연관성을 통해 유용한 정보를 제공
해야 한다는 것을 의미합니다.

공간 정보를 저장하는 방식에 대해서 고민이 많았습니다.

예를 들어 사용자가 어떤 경로를 저장한다면 그 형태는 어떻게 될까요?

우선 일반적인 지도 상에서 위치를 표현하려면 **위도(latitude)**와 **경도(logitude)**로 이루어진 좌표쌍으로 표현하게 됩니다.

그리고 사용자가 이동한 경로는 곧 실수로 이루어진 좌표쌍의 배열이 될 것 입니다.

저희는 이러한 데이터를 저장하고 가공하기 위해 다양한 방법을 생각해보았는데,

크게 3가지 방법이 있었습니다.

#### 1. 하나의 테이블에 위도와 경도 컬럼을 만들고 각 레코드마다 하나의 좌표쌍을 표현한다.

이를 간단히 테이블로 표현하면 아래와 같습니다.

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/99397e07-25a2-46c9-9898-a34b48664b90)

그런데 단순히 이것으로 충분할까요?

좌표들은 경로를 표현해야 하기 때문에 서로의 순서관계가 존재해야 합니다.

따라서 적당히 고유키의 역할도 할겸 순서도 표현해줄 겸 컬럼을 하나 추가해주면 아래와 같습니다.

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/20b7e6bd-e0e2-4f28-a19c-07d1262a970c)

그런데 또 복잡해집니다.

좌표쌍들이 모두 일관된 순서관계를 가지는가?

사용자들의 이동경로는 모두 제각각입니다.

극단적으로 어떤 이동경로는 서로 완전히 정반대의 순서를 지닐 수도 있습니다.

이를 다시 한 번 차근차근 정리하면 다음과 같습니다.

사용자는 여러개의 게시글을 씁니다.

게시글은 하나의 이동경로를 가집니다.

하나의 이동경로는 제각각의 순서로 임의 좌표들을 가지고 있습니다.

이번엔 사용자와 게시글까지 간단히 표현하여 관계도를 그려보겠습니다.

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/045f9535-f0ce-4fdf-b165-727ad469ef39)

이쯤이 되니 제대로 관계를 표현할 수 있을 것 같습니다.

그런데 벌써 머리가 지끈거릴 정도로 처리가 귀찮고 고민할 점도 많아보입니다.

1. ORM의 한계
coordinate:post_route = n:m 관계를 가집니다.
그런데 보통의 ORM은 n:m 관계에 순서관계를 표현하기가 조금 복잡합니다.


```ts

@Entity()
export class Post {
    @ManyToMany(()=> Coordinate)
    route: Coordinate[]
}

```

위와 같이 할 경우

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/5036b1b0-b69a-4f19-a718-473486ab9de0)

사진처럼 단순히 매핑만 시켜줄 뿐,
추가적인 컬럼을 설정할 순 없습니다.

이를 위해선 따로 엔티티 클래스를 만들어주어야만 합니다.

거기다 경로 간에 연관관계를 찾기 위해선 복잡한 수식을 where 절로 걸어주어야 하는데, 인덱스를 어떻게 걸어야 할지도 잘 모르겠습니다.
아마 이 데이터를 단순조회가 아니라 조건문을 걸려고 하면 거의 무조건 풀테이블 스캔을 할 것이라 생각이 들었습니다.

단순 조회나 업로드를 위해서도 신경쓸 부분이 많으리라 생각이 들었습니다.

데이터 정규화를 신경쓴다면,

> 좌표가 이미 업로드되었는지 안되었는지 일일이 조회하여 없는 좌표는 새롭게 레코드로 추가해주고.. 

하여튼 부족한 시간에 너무 생각할 거리가 많다고 생각이 들었습니다.

이에 저희는 하나의 레코드에 온전히 좌표를 저장할 방법은 없을까 생각해보았는데요.

#### 2. JSON 데이터

mysql은 단순 데이터 뿐만 아니라 json 데이터 타입을 지원하는데요.

저장할 수 있는 데이터는 모든 종류의 json 데이터입니다.

그리고 json은 배열('[ ... ]') 형태의 데이터타입을 지원하기 때문에,

이를 이용하면 좌표배열을 하나의 컬럼에 손쉽게 저장할 수 있었습니다.

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/8277287c-df0f-4002-aaf3-215754134cb2)


이제 만약 어떤 좌표 배열을 저장한다면,

```
[[1, 2], [3, 4], ...]
```
혹은
```
[{
"longitude": 1,
"latitude": 2
}, ...]
```

이런 식으로 쉽게 저장할 수 있게 됩니다.
순서관계도 이미 데이터 그 자체로 지니고 있게 되며,
테이블이 분리되어 JOIN을 어떡할지에 대한 고민도 할 필요가 없게 됩니다.

그러나 딱 하나 걸리는 점이 있었다면,

데이터의 처리에 관한 부분입니다.

json은 구조화된 데이터 표현에 적합하기 때문에 mysql도 이 부분에 대한 지원은 어느정도 되어있으나, 수학적 계산을 위해 적합하진 않다고 판단했습니다.

정확히 CRUD만을 위해선 충분히 좋은 대안이지만 완벽하진 않습니다.

#### 3. Geometry 데이터

mysql은 공식적으로 공간 데이터에 대한 지원을 위해 geometry 데이터 타입을 도입하였습니다.

https://dev.mysql.com/doc/refman/8.0/en/spatial-type-overview.html
https://dev.mysql.com/doc/refman/8.0/en/gis-data-formats.html

geometry 데이터는 [Open Geospatial Consortium](www.ogc.org)이란 기관에서 표준을 제정하고 있는데 mysql도 이 표준을 지원하는 데이터 타입을 지원하는 것입니다.

geometry 데이터는 통상적인 공간 형식들을 대부분 지원하는데

Point: 점
Line: 선
Polygon: 닫힌 선들의 집합
MultiPoint: 여러 개의 점
...

등입니다.

정확히 저희의 니즈와 부합하는 데이터 타입이란 것을 알 수 있습니다.

예를 들어 이동 경로를 표현한다면

Line을 통해 표현할 수 있을 것 입니다.

또 geometry 데이터 타입은 강력한 장점이 있는데요.

공간 연산을 위한 다양한 함수를 지원한다는 점입니다.

https://dev.mysql.com/doc/refman/8.0/en/spatial-analysis-functions.html

예를 들어 공간 데이터의 Intersection, Union를 구한다던가
혹은 어떤 공간이 다른 공간을 포함하는지 여부 등

```sql
SELECT * FROM table WHERE ST_CONTAINS(ST_BUFFER(?, 100), point)
-- 현재 반경으로부터 일정 거리 이하에 존재하는 점들을 포함하는 데이터 조회
```

다양한 함수를 통해 데이터를 쿼리의 차원에서 다양하게 가공할 수 있다는 점이었습니다.

마지막으로 또 하나의 매력적인 점이 있었는데요.

바로 공간 데이터를 위한 spatial index가 지원된다는 점이었습니다.

https://dev.mysql.com/doc/refman/8.0/en/creating-spatial-indexes.html

시간이 많이 없어 이론까지 많이 공부는 못했지만,
R-TREE라는 자료구조로 공간 데이터들의 탐색 시간을 줄일 수 있다고 합니다.

이러한 점을 들어 저희는 지도 상에서 사용자의 이동 경로는 Line,
핀이나 지도와 맵핑된 콘텐츠를 표현함에 있어선 Point를 이용하기로 하였습니다.

Geometry 형식을 통해 하나의 컬럼에 데이터에 필요한 공간정보를 한 번에 저장할 수 있게 되어 단순 저장 및 조회에 있어서의 유지보수 편리성을 획득함은 물론,

사용자에게 여행에 도움이 될만한 정보를 추천할 때 공간데이터를 적극 활용하고 있습니다.

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/29b824f2-3c47-44a7-898a-124610c51b0a)


---
    
</details>
    
    
### 로그를 손쉽게 관리하려면 어떡해야 할까? 🔍

<details>
    
---

저희 팀 백엔드는 이번 프로젝트에서 시간 부족으로 인해 테스트 절차를 거의 생략하다싶이 해야했습니다...

그렇기 때문에 어마무시한 에러와 디버깅에 시달려야 했는데요.

배포된 서버에서 발생하는 에러를 24시간 모니터링할 수는 없는 문제였습니다.

그렇기 때문에 저희는 로그를 꼭 기록해야 할 필요성이 생겼는데요!

다행히 Naver Cloud에서는 Log를 기록하고 효율적으로 관리 및 검색할 수 있는 Effective Log Search & Analytics라는 서비스를 제공하고 있었습니다.

https://www.ncloud.com/product/management/elsa

해당 서비스는 어플리케이션 관리를 하며 발생하는 다양한 로그를 API를 통해 손쉽게 기록할 수 있다는 장점이 있었는데요.

이제 남은 문제는 어플리케이션에서 발생하는 로그를 모두 서비스로 보내주기만 하면 됩니다.

방법은 두 가지가 있었는데요.

보내고 싶은 포인트에 모두 따로 로그를 전송하는 코드를 보내주는 방법이 있고,

기존 로깅을 인터셉트하여 로깅 로직에 Elsa 로깅을 추가하는 방법이 있었습니다.

저희는 두 번째 방법을 선택했는데요.

일단 모든 로그를 다시 찍어야 하는 것이 힘든 일이라 느껴졌고,

프레임워크에 로그 모듈에 대한 관리를 위임할 수 있는 것이 좋을 것이라 느꼈습니다.

우선 Nest.js에서 말해주는 커스텀 로깅 모듈에 대한 문서는 아래와 같습니다.

https://docs.nestjs.com/techniques/logger

그리고 Naver Cloud Elsa 서비스를 이용하기 위한 API는 아래와 같습니다.
```
{
    "projectName": "72356c50401b8e20_testproject",
    "projectVersion": "1.0.0",
    "body": "This log message come from HTTPS client.",
    "logLevel": "DEBUG",
    "logType": "WEB",
    "logSource": "https"
}
```
log 레벨이 지정이 가능하고, logSource나 Type도 사실상 마음대로 결정할 수 있습니다.
https://guide.ncloud-docs.com/docs/elsa-elsa-1-5-1

이제 대략적인 흐름은,

1. Nest.js Builtin(ConsoleLogger)를 상속한 뒤,
2. 각각의 로그레벨마다 Axios 요청을 통해 로그 메세지를 elsa 서비스로 전송하는 로직을 추가한다.
3. 개발 환경과 배포 환경에 맞추어 Dependency Injection이 될 모듈을 프레임워크에 위임한다.

로 정리할 수 있겠습니다.

```
./src/logger
├── app.logger.symbol.ts
├── logger.module.ts
├── ncp.elsa.config.dto.ts
├── ncp.elsa.credentials.dto.ts
├── ncp.elsa.log.payload.dto.ts
├── ncp.elsa.logger.config.factory.ts
├── ncp.elsa.logger.provider.ts
└── ncp.elsa.request.dto.ts
```

결과적으로 제작된 폴더 구조는 위와 같은데요.

elsa를 위한 credentials를 관리할 dto와 로그 전송을 위한 dto,
그리고 실질적인 로그 전송을 담당할 logger로 이루어져있습니다.

```ts
@Injectable()
export class NcpEffectiveLogSearchAnalyticsLogger extends ConsoleLogger {
  @Inject()
  private readonly httpService: HttpService;

  @Inject()
  private readonly config: NcpEffectiveLogSearchAnalyticsConfig;

  private sendMessageToElsa(logLevel: any, context: any, message: any) {
      // elsa로 로그를 전송하는 helper 메소드
    this.httpService
      .request({
        ...this.config.request,
        data: {
          ...this.config.credentials,
          body: message,
          logLevel: logLevel,
            // 로그 레벨을 지정해줍니다.
          logSource: context,
            // 로그 소스는 컨텍스트로 지정하는데요.
            // nest.js에서 로깅 컨텍스트는 해당 로거가 주입되어있는
            // 부모 클래스를 지칭합니다.
        },
      })
      .subscribe();
  }

  log(message: any, context?: string): void;
  log(message: any, ...optionalParams: any[]): void;
  log(message: unknown, context?: unknown, ...rest: unknown[]): void {
      // 로그를 출력하기 전 메세지를 인터셉트하여 elsa로 전송합니다.
    this.sendMessageToElsa('log', context, message);
    super.log(message, context, ...rest);
  }
}

```

먼저 간단히 가장 기본적인 로깅 레벨인 'log'를 인터셉트 하는 코드인데요.
사실 여기까지 하면 1., 2.가 끝나버립니다.

나머지 레벨도 모두 똑같은 로직으로 작성해주기만 하면 끝입니다.

코드적으론, 생성자 주입을 하지 않고 프로퍼티 주입을 하였는데,

생성자 주입을 할 경우 부모 클래스의 주입을 그대로 재현해주어야 하기 때문에 프로퍼티 주입을 하였습니다.

이제 모듈 구성은 아래와 같이 합니다.

```ts
@Module({
  imports: [
    ConfigManagerModule.registerAs({
      schema: NcpEffectiveLogSearchAnalyticsConfig,
      path: 'naver.elsa',
    }),
      // 커스텀으로 제작한 ConfigManager 모듈입니다.
      // application.yaml 파일에서 해당 경로의 정보를 로드하여
      // 지정한 DTO 형식으로 생성해줍니다. 
  ],
  providers: [
    {
      provide: APPLICATION_LOGGER_SYMBOL,
      useClass:
        process.env.NODE_ENV === 'production'
          ? NcpEffectiveLogSearchAnalyticsLogger
          : ConsoleLogger,
    },
  ],
    // NODE_ENV가 production 환경일 경우 커스텀 로거를
    // 개발 환경일 경우 Builtin Logger를 위임합니다.
  exports: [APPLICATION_LOGGER_SYMBOL],
})
export class LoggerModule {}
```

위에서 신경쓴 포인트는 하나의 개발환경과 프로덕션 환경의 로거 주입을 다르게 해주는 점이었는데요.

개발 환경의 로그 조차 모두 Ncloud로 보내버리면, 개발환경에서 발생한 로그와 배포환경을 구분할 수 없기 때문에 꼭 설정해주어야만 했습니다.

이제 bootstrap 메인 파일에서

```ts
app.useLogger(app.get(APPLICATION_LOGGER_SYMBOL));
```
와 같이 설정해주면 어플리케이션 시작시 자동으로 nest.js가 상황에 맞는 로거를 오버라이딩해줍니다.

이제 비즈니스 로직에서 

```ts

@Injectable()
export class PostService implements OnModuleInit {
  private readonly logger: Logger = new Logger(PostService.name);
 
    
    async doSomething() {
        this.logger.log(' ... ')
    }
 }

```

와 같이 할 경우 등록된 로거가 알아서 매핑되어 동작하게 됩니다.

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/874dd440-e602-4cb6-a31e-4ac6654112aa)


이제 배포 서버에서 발생하는 로그들은 elsa 서비스에 쌓이고 쌓여서

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/2da3ceb9-8fdf-4e19-9132-ea675b0e27d5)

원하는 로그만 검색을 한다던가,
해당 로그의 +-1분 동안 발생한 쿼리를 열람하는 등의 동작이 간편해집니다.
여기까지 저희의 부족한 테스트 절차를 조금이나마 매꾸어보려는 노력이었습니다.

---
    
</details>
    
### 어떤 전략으로 캐싱을 해야할까? + 동시성과 일관성의 문제(300ms=>30ms) 🗄️

<details>

---
    
![image](https://hackmd.io/_uploads/BkZwK68LT.png)
![image](https://hackmd.io/_uploads/HyW5taIUp.png)

어플리케이션이 어느정도 틀이 잡히면서 서버의 응답속도를 조금이라도 높여야겠다는 필요성이 느껴졌는데요.

우선 저희 서비스에서 가장 많이 호출될 것으로 예상되는 메인화면의 API 응답 형식은 아래와 같습니다.

```
[
  {
    "postId": 0,
    // 게시글 고유 id
    "title": "string",
    // 게시글 제목
    "summary": "string",
    // 게시글 요약
    "imageUrl": "string",
    // 게시글 대표 이미지 url
    "writer": {
      "email": "string",
      "name": "string",
      "imageUrl": "string",
    },
    "likeNum": 0,
    // 좋아요 개수
    "viewNum": 0,
    // 조회수
    // 작성자
    "liked": true
    // 게시글 좋아요 여부
  }
]
```

처음에 고려한 것은 nest.js 자체적으로 제공하는 인메모리 캐시 모듈이었습니다.

https://docs.nestjs.com/techniques/caching

그러나 이 큰 문제가 하나 있었는데요

바로 단순 요청 주소에 따라 모든 캐싱을 분기한다는 점이었습니다.

그러나 응답 데이터를 보시면 알 수 있듯,

조회수나 좋아요는 상당히 빈번하게 변할 수 있는 데이터이고,

좋아요 여부는 현재 로그인 유저에 따라서 매번 응답이 달라져야 하는 데이터입니다.

따라서 저희는 기본 제공 캐시 로직을 사용할 수 없다고 판단했는데요.

여기서 다음과 같은 요소들을 고려해야 했습니다.

1. 우선 데이터의 종류는 크게 3가지 정도로 나눌 수 있습니다.

```
"postId": 0,
// 게시글 고유 id
"title": "string",
// 게시글 제목
"summary": "string",
// 게시글 요약
"imageUrl": "string",
// 게시글 대표 이미지 url
"writer": {
  "email": "string",
  "name": "string",
  "imageUrl": "string",
}
```
게시글의 콘텐츠 관련 데이터와 작성자 관련 데이터는 수정이 빈번하지 않고, 조회가 빈번한 데이터입니다.
또한 어떤 사용자가 요청하건 같은 내용물이 응답되어야 합니다.

```
"likeNum": 0,
// 좋아요 개수
"viewNum": 0,
// 조회수
```

좋아요와 조회수 데이터는 조회와 수정이 모두 빈번한 데이터라고 판단했습니다. 대신 데이터의 일관성 보다는 동시성이 중요한 데이터라고 판단이 들었습니다.

```
"liked": true
// 게시글 좋아요 여부
```
좋아요 여부는 어떤 유저가 요청하냐에 따라 매번 다른 응답을 주어야 하는 데이터입니다.
    
2. 유저에 따라 달라져야 하는 좋아요, 조회수 처리
    
좋아요가 유저-게시글 당 반드시 한 번만 가능해야 함은 명백합니다.
조회수 또한 유저가 게시글을 보는 매번 올릴 순 없기 때문에
유저가 게시글을 이미 봤다면 적어도 한동안은 조회수가 올라감을 방지해야 합니다.
    
즉, 이는 좋아요, 조회수가 단순히 카운팅만 하고 끝내는 로직으로 처리하긴 힘들다는 점을 의미합니다.

3. 좋아요의 동시성 문제
    
그렇다면 좋아요를 한 유저의 관리는 데이터베이스에서 관리하고 카운팅만 분리하면 어떨까요?
    
```ts
# 게시글 좋아요 요청
@Transactional()
async like(user, post) {
    if(!isLiked(user, post)) {
        setLike(user, post);
        incrementLikeCount(post);
    } else {
        unsetLike(user, post);
        decrementLikeCount(post);
    }
}
```
그럴듯 하지만 문제가 생기게 되는데요    
    
한 명의 유저가 빠른 속도로 좋아요를 누를 경우
```
connection 1 START TRANSACTION
connection 2 START TRANSACTION

connection 1 좋아요 여부 확인 => false
connection 2 좋아요 어부 확인 => false

connection 1 좋아요 추가
connection 2 좋아요 추가 => DUPLICATE ENTRY(게시글-유저 관계)

connection 1 좋아요 개수 추가
connection 2 ROLLBACK

connection 1 COMMIT
```
좋아요를 추가하는 시나리오에선 위와 같이 Transaction에 의해
connection 2의 중복된 요청이 실패하고 increment가 진행되지 않습니다.
    
그러나,
    
좋아요를 취소하는 시나리오에선

```
connection 1 START TRANSACTION
connection 2 START TRANSACTION

connection 1 좋아요 여부 확인 => false
connection 2 좋아요 어부 확인 => false

connection 1 좋아요 취소
connection 2 좋아요 취소

connection 1 좋아요 개수 감소
connection 2 좋아요 개수 감소

connection 1 COMMIT
connection 2 COMMIT
```
좋아요를 취소하는 것은 중복 여부를 체크하지 못하기 때문에
likeNum이 두 번 모두 감소하며 commit이 완료되어버립니다.

극단적으론 좋아요가 음수가 되어버립니다.
    
현재 서버 로직상 좋아요에 대한 validation을 진행 중이므로

```ts
export class PostSearchResponse {
    ...
  @ApiProperty({ description: '좋아요 개수' })
  @Min(0)
  @IsInt()
  likeNum: number;
    ...
}

```
    
서버가 맛이 가버리는 상황이 나타나기도 했습니다.
그렇다고 좋아요가 마이너스인 상황은 사용자에게도 꽤 눈에 띄는 오류일 것이라 생각이 들었구요.

이에 해결방안으로는 Exclusive Lock을 걸어주는 방법이 있었는데요.
조회 속도를 늘리기 위해 노력하는 와중에 Lock을 걸어 대기를 시키는 것은 상당히 아쉬운 결정이었습니다.
심지어 InnoDB는 gap lock을 통해 주변 레코드까지 락을 걸어버리니
겨우 좋아요로 인해 감당할 비용이 너무 크다고 느껴졌습니다.
    
#### 그래서 어떤 전략인데?
    
결론적으론 게시글의 데이터를 각 성격에 맞게 각자의 전략을 만들어 캐싱하기로 결정하였습니다.
데이터의 저장은 다양한 데이터타입과 연산, 빠른 속도가 보장되는 레디스에게 위임하는 것이 좋겠다고 생각이 들었습니다.

```
"postId": 0,
// 게시글 고유 id
"title": "string",
// 게시글 제목
"summary": "string",
// 게시글 요약
"imageUrl": "string",
// 게시글 대표 이미지 url
"writer": {
  "email": "string",
  "name": "string",
  "imageUrl": "string",
}
```
결론적으론 게시글의 콘텐츠 데이터는 Cache를 우선 체크하고,
Cache miss가 날 때 DB에서 조회하여 Cache를 업데이트하는 방식으로 결정하였습니다.

![image](https://hackmd.io/_uploads/BJnldhB8a.png)
    
```
"likeNum": 0,
// 좋아요 개수
"viewNum": 0,
// 조회수
"liked": true
// 게시글 좋아요 여부
```
게시글의 좋아요와 조회수의 경우 
[좋아요 개수 조회 최적화](https://tecoble.techcourse.co.kr/post/2022-10-10-like-count/)
위 게시글에서 힌트를 얻었는데요.

좋아요와 조회수는 수정, 조회가 빈번하지만 데이터베이스에 즉시 영속화되어야 할만큼 중요한 정보는 아니라고 생각이 들었습니다.

따라서 모든 수정과 조회는 캐시에 진행하고 적절한 스케쥴링을 통해 데이터베이스에 반영하기로 결정하였습니다.

![image](https://hackmd.io/_uploads/rJOwt2H86.png)
    
#### 구현은?
    
우선 캐시를 저장하는 것은 Redis를 이용하기로 하였는데요.
    
게시글 콘텐츠의 경우 Json 데이터 타입을 이용해 저장하였습니다.
    
단순히 게시글을 JSON.stringfy하여 텍스트로 저장하는 것보단,
공식적으로 지원되는 데이터 타입이 좋겠다고 생각이 들었습니다.
또 json을 위한 Fulltext indexing을 따로 지원하여 추후 캐시에 대한 검색 등에 있어서도 좀 더 유리할 것이라 생각했습니다.

또 게시글을 리스트 단위로 저장하는 것보단, 각 게시글마다 따로 저장하고 조회하여(MGET 커맨드 이용) Cache hit 빈도를 높이고 싶었습니다.
    
![image](https://hackmd.io/_uploads/Hywya3rLa.png)

한편, 좋아요와 조회수는 sets를 이용해 저장하기로 했는데요.
좋아요는 물론, 조회수도 한 유저가 중복적인 요청을 하였다고 해서 매번 조회수를 1씩 카운트하면 안되기 때문에
두 데이터 모두 어떤 유저가 좋아요를 했고, 조회를 했는지 저장해서 주기적으로 데이터베이스에 반영하는 것이 좋을 것이라 생각했습니다.
    
![image](https://hackmd.io/_uploads/Hym1A2rLa.png)

이제 어떤 게시글에 대한 요청이 들어올 시
```ts
    
    let postId = ....
    let email = ....
    let post = redis.JSON.GET(postId);
    // 게시글을 조회합니다.
    if(!post) {
        //게시글이 없을 시 DB에서 로딩하고 Cache도 업데이트해줍니다.
        post = mysql.select(postId);
        redis.JSON.SET(postId, post);
    }
    // 좋아요와 조회수, 좋아요 여부를 획득
    let likeNum = redis.SETCARD(postId);
    let viewNum = redis.SETCARD(postId);
    let isLiked = redis.SETISMEMBER(postId, email)
    // 응답 형태로 가공합니다.
    return {
        ...post, likeNum, viewNum, isLiked
    }
```
위와 같이 처리하는 시나리오로 진행하게 됩니다.

만약 여러 게시글에 대한 요청이 들어오는 경우
```ts
     let postIds = mysql.select(postId).from(post).where(...);
     // JOIN이 사라지고 로딩할 데이터가 postId만 남아 쿼리 실행시간이 줄어듭니다.
    let posts = redis.JSON.MGET(postIds);
    let cacheMissedPostIds = postIds.filter((postId, index)=> !posts[index]);
    // 캐시 미스된 포스팅들
    let dbPosts = mysql.select(...).from(post).where((postId In cacheMissedPostIds));
    ...
```
    
좋아요, 조회 요청이 들어올 시
```ts    
    redis.SETADD(postId, email);
    // 좋아요
    if(redis.SETISMEMBER(email)) {
        redis.SETREM(postId, email);
    } else {
        redis.SETADD(postId, email);
    }
```
와 같이 처리하게 됩니다.
    
마지막으로 신경쓸 부분은 스케쥴링을 통해 좋아요와 조회 정보를 데이터베이스로 영속화하는 부분이었습니다.
    
```ts
    @Cron('0 0 * * * *')
  async updateTaskToViewsAndLikesAndScores() {
    ...
  }
```

저희 팀은 이러한 작업을 통해
쿼리 요청을 최대한 줄여 특히 메인화면의 경우 캐시 히트가 잦아
응답시간을 250~350ms에서 20~40ms까지 줄여볼 수 있었는데요.
    
다양한 성격의 데이터를 어떻게 처리할까에 대해서 고민을 많이 해볼 수 있어 좋은 시간이었습니다.
    
그러나 이로 인해 게시글 관련 API를 조회할 경우 서버 내부 코드에서는
기존 보다 한 계층을 더 거쳐야 할 정도로 로직이 복잡해지는 부분도 있었는데요.
    
캐싱 로직을 좀 더 비즈니스 로직에서 분리하고 싶었으나,
아직까진 마땅한 아이디어를 찾지 못했습니다.
    
추후에는 리팩토링과 함께 해당 부분을 건드려보고 싶습니다.
    
</details>


---


이 외에도 Macro 팀의 [고민Log](https://www.notion.so/Log-ce0c7e4f23024c6d809983ec249b02f1) 구경해보세요


## Backend Infrastructure

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/b41a3e1b-27f8-48e8-b815-dc38278c22b0)

<details>

### Network
---

#### Naver Cloud VPC & Load Balancer

- 내부 사설망을 통해 Database <-> Application Server 간 안전한 통신 보장
- L7 HealthCheck를 통한 모니터링 지원

### Application
---

#### MySQL

- 팀원들에게 가장 익숙한 관계형 DB
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
- 익숙한 express 미들웨어 기반의 MVC 구조 지원
- Typescript의 Decorator 패턴에 대한 강력한 지원
- AOP(Aspects Oriented Programming) 지원
- 다양한 ORM(TypeORM) 및 패키지 간 호환성

### CI/CD
----

#### Github Actions

- 간편한 구축과 테스트
- 자체적으로 지원하는 클라우드 인스턴스
- Github secret을 통해 지원하는 credentials 관리

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/004a8f65-fdc3-4649-8d33-aae5c19b7f2e)


#### Docker

- 개발환경과 배포환경의 일관성 보장
- 간편한 빌드 프로세스 지정
- NCLoud Container Registry를 통한 보안성 확보

### Authentication
----

#### JWT

- 간편한 인증과 관리
- 유연한 Payload 정보를 통한 Authentication과 Authorization 절차 간편화

#### Apple OAuth2

- 회원가입과 탈퇴 절차 간편화
- 앱스토어 배포 필수 절차

### Contents Delivery

---

#### Naver Cloud Object Storage(S3)

- Amazon S3와 호환되는 API

### Logging

---

#### Naver Cloud Effective Log Search Analytics

- 로그 저장 및 다양한 쿼리를 통한 검색 기능 지원
- 간편한 API와 다양한 시각화 기능

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/c4d21910-c4e4-4e8e-b9fc-38574a700809)


### Communication
----

#### Swagger

- API 개발과 문서 작성의 업무 통합
- 간편한 테스트 기능

![image](https://github.com/boostcampwm2023/iOS03-TravelShare/assets/37203016/9d4a611f-18aa-4224-9246-383a8c29d10e)

---

</details>

## 공부 Log
    
### 김경호의 HexColor 공부
<details>
    
- HexCode 구성: HexCode는 16진수 6자리로 구성되며, 각각의 2자리는 Red, Green, Blue를 나타냄
- UIColor에서의 사용: UIColor에서는 R, G, B 값을 각각 나눠서 넣어줘야 합니다. 이를 위해 HexCode를 2자리씩 나눠서 계산합니다.

계산 방법:

HexCode를 2자리씩 나누기 위해 >> 연산자를 사용하여 밀어주고, & 연산자를 통해 나머지 값을 제거합니다.
계산하고자 하는 자리수를 하위 8자리로 만들어줍니다.
0xFF와의 & 연산을 통해 다른 자리를 제거합니다.
그 결과를 Double로 변환하고, 255.0으로 나눠줌으로써 값을 계산합니다.
이 방식을 사용하면 HexCode를 RGB 값으로 변환할 수 있습니다.
</details>
    
## 🏡 팀 페이지

:pushpin: [Notion](https://necessary-grin-f0b.notion.site/ed1785c63de744659485ba8b78125281?pvs=4)

## 🤝 우리의 약속

| 그라운드 룰 | Commit Convention | Issue Convention | PR Convention |
| -------- | -------- | -------- | -------- |
| :pushpin: [그라운드 룰](https://necessary-grin-f0b.notion.site/d45a562d318049d48164335c3e9e562d?pvs=4)     | :pushpin: [Commit Convention](https://necessary-grin-f0b.notion.site/Commit-Convention-b750a1e1db7342edbc2d3956b1841d0e?pvs=4)     | :pushpin: [Issue Convention](https://necessary-grin-f0b.notion.site/Issue-Convention-54d447f4915c4efba9519eba91bab816?pvs=4)     | :pushpin: [PR Convention](https://necessary-grin-f0b.notion.site/PR-Convention-e095863a5dd54b9eba42692dcf61eb19?pvs=4)     |

