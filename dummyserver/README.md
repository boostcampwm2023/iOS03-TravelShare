## dummyserver
 더미데이터 생성 및 테스트용 서버
# 실행 방법

VsCode를 실행하고 ctrl+shift+~ 눌러 터미널을 연다.</br>
서버 실행 명령어:</br>
```bash
npm run start
```
web에서 [localhost:3000](http://localhost:3000) 입력 시 현재 post_info json 형태 확인 가능</br>
url 창에 [localhost:3000/post_info](http://localhost:3000/post_info)를 입력하면 json 형태로 쉽게 받아올 수 있다.</br>

# DB

현재 AWS 서버에 올라가있다.</br>
ip와 DNS는 재실행할 때마다 바뀌는데,
이떄문에 재실행할 때, 카톡방에 최신화하도록 하겠습니다.
이제 한도가 얼마남지 않아서 밤이거나 할때는 중지해놓도록 하겠습니다.
불편한 점 양해부탁드립니다.
naver cloud 사용 시 좀 더 안정화하도록 하겠습니다.

dns: 카톡방 참고, [config](./mysql.config.js)에 주석을 참고하여 수정하여 주시면 됩니다.
ip: 카톡방 참고
port: 3306 고정</br>
id: macro, pw:macro</br>
[HeidiSQL](https://www.heidisql.com/) 다운 받아서 실행하면 dummyData를 쉽게 생성하고 관리할 수 있다.</br>

# 23/11/03
## 추가 사항
- mysql schema 설계
- / : main 화면. post_info 예쁜 json 형태
- /post_info : post_info json api
- 아직 사진부분은 구현 하지 않았다