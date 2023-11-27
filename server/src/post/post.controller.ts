import {
  BadRequestException,
  Body,
  Get,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOkResponse,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { PostFindResponse } from './post.find.response.dto';
import { PostDetailResponse } from './post.detail.response.dto';
import { PostFindQuery } from './post.find.query.dto';
import { PostService } from './post.service';
import { AuthenticatedUser } from 'src/auth/auth.decorators';
import { Authentication } from 'src/auth/authentication.dto';
import { RestController } from 'src/utils/rest.controller.decorator';
import { PostHitsQuery } from './post.hits.query.dto';
import { PostDetailQuery } from './post.detail.query.dto';
import { PostUploadBody } from './post.upload.body.dto';
import { PostUploadResponse } from './post.upload.response.dto';
import { PostLikeQuery } from './post.like.query.dto';
import { PostLikeResponse } from './post.like.response.dto';
import { PostKeywordAutoCompleteQuery } from './post.keyword.autocomplete.query.dto';
import { AutoCompleteService } from 'src/utils/autocomplete.service';
import { plainToInstance } from 'class-transformer';
import { PostKeywordAutoCompleteResponse } from './post.keyword.autocomplete.response.dto';

@ApiTags('Post')
@ApiBearerAuth('access-token')
@RestController('post')
export class PostController {
  constructor(
    private readonly postService: PostService,
    private readonly autoCompleteService: AutoCompleteService,
  ) {}

  @ApiOperation({
    summary: '인기 게시글 리스트 조회, 테스트 중이지만 사용 가능',
    description: `
# post/hits

- 2주 전부터 작성된 게시글을 조회수와 인기도 기준으로 정렬하여 제공합니다.
- query parameter로 pagination 기능을 제공합니다. 

`,
  })
  @ApiResponse({
    type: [PostFindResponse],
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
    summary: '게시글을 검색하는 API입니다.',
    description: `
# post/search

- 게시글 검색 API입니다.
- 제목과 유저 이름을 기준으로 검색할 수 있는데,
둘다 Optional이고 둘다 넣어도 됩니다.
- 일단 단어나 키워드가 제목 안에 포함되어있어야 합니다.
\`\`\`
# 참고 sql
SELECT ... FROM post ... WHERE title LIKE '%:title%' OR '%:user:%';
\`\`\`
`,
  })
  @ApiResponse({ description: '리스트 조회', type: [PostFindResponse] })
  @Get('search')
  async search(
    @Query() query: PostFindQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.postService.search(query, user);
  }

  @ApiOperation({
    summary: '게시글 상세 정보를 조회합니다.',
    description: `
# post/detail

- 주어진 id에 대해 게시글의 상세 정보를 불러옵니다.
- query로 id만 꼭 명시해주어야 합니다.
- route와 hashtag는 각각 2차원, 1차원 배열 형태입니다.
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
## route.coordinates 혹은 route.routeId를 반드시 설정해야 합니다.
 1. 미리 경로를 /route/upload를 통해 업로드했을 경우 반환받은 routeId를 넣으면 됩니다.
 2. 혹은 route.coordinates에 직접 경로를 넣어서 곧바로 업로드도 가능합니다.
- 응답은 게시글 고유 id입니다.

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
    if (!('routeId' in post.route) || !('coordinates' in post.route)) {
      throw new BadRequestException(
        'routeId와 coordinates 중 하나가 반드시 설정되어야 합니다.',
      );
    }
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
  async keywordAutoComplete(
    @Query() { keyword }: PostKeywordAutoCompleteQuery,
  ) {
    return plainToInstance(
      PostKeywordAutoCompleteResponse,
      this.autoCompleteService.search(keyword),
    );
  }
}
