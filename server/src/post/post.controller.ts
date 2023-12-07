import { Body, Get, Patch, Post, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOkResponse,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { PostDetailResponse } from './post.detail.response.dto';
import { PostService } from './post.service';
import { AuthenticatedUser } from 'auth/auth.decorators';
import { Authentication } from 'auth/authentication.dto';
import { RestController } from 'utils/rest.controller.decorator';
import { PostHitsQuery } from './post.hits.query.dto';
import { PostDetailQuery } from './post.detail.query.dto';
import { PostUploadBody } from './post.upload.body.dto';
import { PostUploadResponse } from './post.upload.response.dto';
import { PostLikeQuery } from './post.like.query.dto';
import { PostLikeResponse } from './post.like.response.dto';
import { PostKeywordAutoCompleteQuery } from './post.keyword.autocomplete.query.dto';
import { KeywordAutoCompleteService } from 'utils/keyword.autocomplete.service';
import { plainToInstance } from 'class-transformer';
import { PostKeywordAutoCompleteResponse } from './post.keyword.autocomplete.response.dto';
import { PostSearchResponse } from './post.search.response.dto';
import { PostSearchQuery } from './post.search.query.dto';
import { PostFindQuery } from './post.find.query.dto';
import { PostListQuery } from './post.list.query.dto';

@ApiTags('Post')
@ApiBearerAuth('access-token')
@RestController('post')
export class PostController {
  constructor(
    private readonly postService: PostService,
    private readonly autoCompleteService: KeywordAutoCompleteService,
  ) {}

  @ApiOperation({
    summary: '인기 게시글 조회 v3',
    description: '',
  })
  @ApiResponse({ type: [PostSearchResponse] })
  @Get('list')
  async list(query: PostListQuery, user: Authentication) {
    return await this.postService.list(query, user);
  }

  @ApiOperation({
    summary: '인기 게시글 리스트 조회',
    description: `
# post/hits

- 2주 전부터 작성된 게시글을 조회수와 인기도 기준으로 정렬하여 제공합니다.
- query parameter로 pagination 기능을 제공합니다. 

`,
  })
  @ApiResponse({
    type: [PostSearchResponse],
    description:
      '응답 데이터에서 liked를 수집하는 방법에 대해 논의가 좀 더 필요한 상황입니다.',
  })
  @Get('hits')
  async default(
    @Query() query: PostHitsQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.postService.popularList(query, user);
  }

  @ApiOperation({
    summary: '인기 게시글 조회 v2입니다.',
    description: `
# post/hits/v2

- post/hits와 같은 기능입니다.
- 알고리즘을 개선하였습니다.
- 인덱싱 적용을 통한 속도 개선과 팔로워 정보도 반영이 되었습니다.

    `,
  })
  @ApiResponse({ type: PostSearchResponse })
  @Get('hits/v2')
  async hitsV2(
    @Query() query: PostHitsQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.postService.hits(query, user);
  }

  @ApiOperation({
    summary: '게시글을 검색하는 API입니다.',
    description: `
# post/search

- 게시글 검색 API입니다.
- 제목과 유저 이름을 기준으로 검색할 수 있는데,
둘다 Optional이고 둘다 넣어도 됩니다.
- 여러개의 옵션이 있어 스키마를 참고해주시기 바랍니다.
- keyword 옵션으로 검색할 경우 제목과 내용을 모두 살펴보고 검색 결과를 반환합니다.
- 제목, 내용 관련하여 fulltext index 및 검색 옵션이 적용되어 검색어에 가장 가까운 순으로 결과를 정렬하여 보여줍니다.

`,
  })
  @ApiResponse({ description: '리스트 조회', type: [PostSearchResponse] })
  @Get('search')
  async search(
    @Query() query: PostSearchQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    if ('title' in query) {
      this.autoCompleteService.insert(query.title);
    }
    return await this.postService.search(query, user);
  }

  @ApiOperation({
    summary: '게시글 상세 정보를 조회합니다.',
    description: `
# post/detail

- 주어진 id에 대해 게시글의 상세 정보를 불러옵니다.
- query로 id만 꼭 명시해주어야 합니다.
- route는 이동 경로를 나타낼 좌표 배열,
- contents는 캐러셀 뷰에 들어갈 이미지와 설명, 좌표로 이루어진 배열
- pins는 지도에 핑이 찍힐 위치와 위치에 대한 메타데이터(상호명, 주소, 등)

`,
  })
  @ApiOkResponse({ description: '상세 조회', type: PostDetailResponse })
  @Get('detail')
  async detail(
    @Query() query: PostDetailQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.postService.detail(query, user);
  }

  @ApiOperation({
    summary: '게시글을 업로드합니다.',
    description: `
# post/uplaod

- 게시글을 업로드합니다.
- imageUrl 등은 필수값이 아니므로 잘 확인해주세요.
- ### 경로는 route를 통해 설정할 수 있습니다.
- public 인자를 통해 게시글 공개여부를 설정할 수 있습니다.
## route.coordinates와 pins를 설정해야 합니다.
- coordinates는 이동경로로 저장한 좌표배열을 의미하고,
- pins는 핑찍은 장소들에 대한 좌표배열입니다.
- pins를 저장할 때는 몇 가지 정보들이 더 필요한데,
map api를 통해 불러온 정보들을 그대로 사용하면 됩니다.
- 장소를 구별하기 위해 place_id가 꼭 필요한데, kakao map api 검색을 통해 응답받은
id 항목을 넣어주어야 합니다.

`,
  })
  @ApiOkResponse({
    description: '성공 시에 게시글 고유 id를 반환합니다.',
    type: PostUploadResponse,
  })
  @ApiBody({ description: '업로드', type: PostUploadBody })
  @Post('upload')
  async upload(
    @Body() post: PostUploadBody,
    @AuthenticatedUser() user: Authentication,
  ) {
    this.autoCompleteService.insert(post.title);
    return await this.postService.upload(post, user);
  }

  @ApiOperation({
    summary: '게시글을 좋아요하거나 취소합니다.',
    description: `
# post/like

- 현재 로그인한 유저를 기준으로 해당 게시글의 좋아요를 동작시킵니다.
- 토글 형식으로 이미 좋아요를 눌렀을 경우 취소시키고 다시 누르면
다시 좋아요시키는 식으로 작동합니다.
`,
  })
  @ApiOkResponse({
    description: '요청 성공 시에 해당 게시글 좋아요 수를 반환합니다.',
    type: PostLikeResponse,
  })
  @Patch('like')
  async like(
    @Query() query: PostLikeQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.postService.like(query, user);
  }

  @ApiOperation({
    summary: '자동 검색어 완성 결과를 응답합니다.',
    description: `
  # post/keyword?autocomplete={검색어}

  - 키워드에 따라 검색어를 자동완성시킵니다.
    `,
  })
  @Get('keyword')
  async keywordAutoComplete(@Query() { query }: PostKeywordAutoCompleteQuery) {
    return plainToInstance(
      PostKeywordAutoCompleteResponse,
      this.autoCompleteService.search(query),
    );
  }

  @ApiOperation({
    summary: '핀 위치를 기준으로 같이 다녀간 인기장소들을 보여줍니다.',
    description: `
# post/find

- 핀의 장소 id(placeId)를 기준으로 주변 인기장소들을 보여줍니다.
- 많은 게시글이 함께 다녀간 장소들을 보여줍니다.
- postNum은 게시된 횟수를 보여줍니다.
    `,
  })
  @Get('find')
  async find(@Query() query: PostFindQuery) {
    return await this.postService.findByPlaceId(query);
  }
}
