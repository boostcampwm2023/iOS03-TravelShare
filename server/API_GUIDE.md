# API 가이드라인

API의 사용 용도에 대해서 대략적으로 흐름을 설명합니다.
정확한 형식은 Swagger 문서를 참고해주세요

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

## Post API

게시글 관련 api는 /post를 통해 찾을 수 있습니다.

1. /post/find는 게시글 리스트를 응답합니다.
2. /post/