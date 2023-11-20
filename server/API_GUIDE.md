# API 가이드라인

API의 사용 용도에 대해서 대략적으로 흐름을 설명합니다.
정확한 형식은 Swagger 문서를 참고해주세요

체크되지 않은 api들은 아직 미구현입니다.

## Login Flow

대부분의 API는 Access Token이 공통 헤더로 포함되어야 합니다.

Access Token을 얻는 방법은
1. /user/signup, /user/signin을 통해 아이디, 패스워드를 통한 정석적인 회원가입 혹은 로그인을 하거나
2. /apple/auth를 통해 애플 소셜 로그인을 하는 방법입니다.

이제 응답받은 Access Token은 http request header에 

```
GET /someApi HTTP/1.1
...
Authorization: Bearer ${Access Token}
...
```
의 형식으로 포함되어야 합니다.

Access Token은 JWT Token으로 base64 encoding 되어있고,
'.'을 기준으로 다음과 같이 3개의 파트로 나뉘어 있습니다.
```
header.payload.signature
```
로 header와 payload는 base64 decode 후 JSON 객체로 파싱이 가능합니다.

```
payload {
    ...
    exp: 1414...
    ...
}
```
위와 같이 payload.exp는 토큰의 만료기한을 포함합니다.

Access Token 발급 시에 exp를 함께 포함할 것이지만, 정확한 토큰의 만료 기한은 토큰을 직접 파싱하여도 알 수 있습니다.

### Apple Login

Apple 로그인 flow는 다음과 같습니다.

1. Client에서 Apple Login를 통해 identityToken 및 authorizationCode 발급
2. app server로 인증 요청(/apple/auth)
3. access-token 응답.

이 때 access-token은 apple에서 발급된 access, refresh 토큰과 관련이 없습니다.

## Post API

게시글 관련 api는 /post를 통해 찾을 수 있습니다.

1. [x] /post/find는 게시글 리스트를 응답합니다. 데이터가 약간 생략됨
2. [x] /post/detail 한 개의 게시글에 있는 데이터를 모두 반환합니다.
3. [x] /post/like 주어진 게시글 id의 게시글을 좋아요합니다.
4. [x] /post/unlike 주어진 게시글 id의 게시글의 좋아요를 취소합니다.

## User API

유저에 관련한 작업들은 /user를 통해 수행합니다.

1. [x] /user/signup은 정석적인 회원가입입니다.
2. [x] /user/signin은 정석적인 로그인입니다.(id, password)
3. [ ] /user/signout은 유저를 로그아웃시킵니다.
4. [x] /user/delete는 유저 회원탈퇴를 수행합니다.
5. [ ] /user/update는 유저 정보를 수정합니다.
6. [ ] /user/profile은 유저 정보를 조회합니다.
7. [ ] /user/follow는 다른 유저를 팔로우합니다.
8. [ ] /user/unfollow는 다른 유저의 팔로우를 취소합니다.
9. [ ] /user/followers는 팔로워를 조회합니다.
10. [ ] /user/followings는 팔로잉 중인 유저들을 조회합니다.

## Map API
[참고](https://github.com/boostcampwm2023/iOS03-Macro/pull/41) <br>
map api는 카카오 혹은 네이버를 통해 위치 관련 정보를 
/map이 구형(네이버) /map/v2가 신형(카카오)입니다.

1. [x] /map/search
2. [x] /map/v2/searchByAccuracy는 주어진 키워드에 정확도 순으로 장소 검색 결과를 제공합니다.
3. [x] /map/v2/searchByDistance는 주어진 키워드와 좌표에 따라 가까운 장소로 키워드 검색 결과를 제공합니다.

