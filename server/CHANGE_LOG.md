# :bookmark: API CHANGE LOG

api가 변경되는 부분이 있을 시 작성하는 문서입니다.


### :calendar: 2023-11-29
:heavy_check_mark: /post/upload: 게시글 업로드 시에 pings 객체가 추가되었습니다.
pings 객체는 place 객체의 배열이며, place 객체의 배열은
/map/v2/search* api를 통해 얻는 정보들을 저장합니다.

:heavy_check_mark: /map/v2/search* api를 통해 조회한 정보들을 서버에서 place_id를 통해 구분은 가능하지만, place_id를 통해 여타 정보를 불러올 방법이 없습니다.
따라 저장할 방법이 없습니다.

이때문에 일단 상호명, 전화번호 등 필요한 정보는 모두 place 객체에 저장하여 데이터베이스에 저장해야 하는 상황입니다.

:bow_and_arrow: [PostUploadBody](./src/post/post.upload.body.dto.ts)

:heavy_check_mark: /post/detail: 게시글 조회 시에 pings 객체가 추가되었습니다.

:bow_and_arrow: [PostDetailResponse](./src/post/post.detail.response.dto.ts)

---
### :calendar: 2023-11-30
:heavy_check_mark: /post/hits: sortBy 옵션 추가. 기존 인기순 정렬은 hot, 최신순 정렬은 latest 옵션을 주면 됩니다.

:heavy_check_mark: /post/upload, detail: swagger 문서 dto required property 수정

---
### :calendar: 2023-12-03
:heavy_check_mark: /post/like: 빠른 시간에 여러번 좋아요할 경우 데이터 부정합이 발생하는 문제를 해결했습니다.

:heavy_check_mark: /post/search: content와 keyword를 통해 검색할 수 있는 기능을 추가했습니다.

:bow_and_arrow: [PostSearchQuery](./src/post/post.search.query.dto.ts)

:heavy_check_mark: /user/follow: /post/like와 마찬가지로 데이터 부정합이 발생할 수 있는 문제를 해결했습니다.

:heavy_check_mark: /user/search: 유저 검색 기능을 추가했습니다.

:bow_and_arrow: [UserSearchQuery](./src/user/user.search.query.dto.ts) :bow_and_arrow: [UserSerachResponse](./src/user/user.search.response.dto.ts)

:heavy_check_mark: /user/followers, followees: 응답 DTO를 profile과 일치시켰습니다.
:bow_and_arrow: [UserFollowersQuery](./src/user/user.followees.query.dto.ts)
:bow_and_arrow: [UserFollowersResponse](./src/user/user.followers.response.dto.ts)
:bow_and_arrow: [UserFolloweesQuery](./src/user/user.followees.query.dto.ts) 
:bow_and_arrow: [UserFolloweesResponse](./src/user/user.followees.response.dto.ts)

