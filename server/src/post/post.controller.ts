import { Body, Get, Patch, Post, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { PostFindResponse } from './post.find.response.dto';
import { PostDetailElement } from './post.detail.response.dto';
import { PostWriteBody } from './post.write.body';
import { PostFindQuery } from './post.find.query.dto';
import { PostService } from './post.service';
import { AuthenticatedUser, Public } from 'src/auth/auth.decorators';
import { Authentication } from 'src/auth/authentication.dto';
import { RestController } from 'src/utils/rest.controller.decorator';
import { PostHitsQuery } from './post.hist.query.dto';
import { PostDetailQuery } from './post.detail.query.dto';

@ApiTags('Post')
@ApiBearerAuth('access-token')
@RestController('post')
export class PostController {
  constructor(private readonly postService: PostService) {}

  @ApiOperation({ description: '인기 게시글을 반환합니다.' })
  @ApiResponse({ type: [PostFindResponse] })
  @ApiQuery({ type: PostHitsQuery })
  @Public()
  @Get('hits')
  async default(
    query: PostHitsQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    const a = await this.postService.popularList(query, user);
    return a;
  }

  @ApiResponse({ description: '리스트 조회', type: [PostFindResponse] })
  @ApiQuery({ description: '제목 검색', type: PostFindQuery })
  @Get('search')
  async search(
    @Query() query: PostFindQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.postService.search(query, user);
  }

  @ApiResponse({ description: '상세 조회', type: PostDetailElement })
  @ApiQuery({ description: '게시글 id' })
  @Get('detail')
  async detail(
    @Query() query: PostDetailQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.postService.detail(query, user);
  }

  @ApiBody({ description: '업로드', type: PostWriteBody })
  @Post('upload')
  async upload(
    @Body() post: PostWriteBody,
    @AuthenticatedUser() user: Authentication,
  ) {
    await this.postService.upload(post, user);
  }

  @ApiOperation({ description: '게시글 좋아요' })
  @ApiQuery({ description: '게시글 id' })
  @Patch('like')
  async like(
    @Query() query: PostDetailQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    await this.postService.like(query, user);
  }
}
