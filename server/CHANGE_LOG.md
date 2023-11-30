# API CHANGE LOG

api가 변경되는 부분이 있을 시 작성하는 문서입니다.

### 2023-11-29
- /post/upload: 게시글 업로드 시에 pings 객체가 추가되었습니다.
pings 객체는 place 객체의 배열이며, place 객체의 배열은
/map/v2/search* api를 통해 얻는 정보들을 저장합니다.

/map/v2/search* api를 통해 조회한 정보들을 서버에서 place_id를 통해 구분은 가능하지만, place_id를 통해 여타 정보를 불러올 방법이 없습니다.
따라 저장할 방법이 없습니다.

이때문에 일단 상호명, 전화번호 등 필요한 정보는 모두 place 객체에 저장하여 데이터베이스에 저장해야 하는 상황입니다.

참고 [PostUploadBody](./src/post/post.upload.body.dto.ts)

- /post/detail: 게시글 조회 시에 pings 객체가 추가되었습니다.

참고 [PostDetailResponse](./src/post/post.detail.response.dto.ts)

### 2023-11-30
- /post/hits: sortBy 옵션 추가. 기존 인기순 정렬은 hot, 최신순 정렬은 latest 옵션을 주면 됩니다.
- /post/upload, detail: swagger 문서 dto required property 수정