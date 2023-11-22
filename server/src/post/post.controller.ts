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
import { PostReadResponse } from './post.read.response.dto';
import { PostWriteBody } from './post.write.body';
import { PostFindQuery } from './post.find.query.dto';
import { plainToInstance } from 'class-transformer';
import { PostService } from './post.service';
import { AuthenticatedUser } from 'src/auth/auth.decorators';
import { Authentication } from 'src/auth/authentication.dto';
import { RestController } from 'src/utils/rest.controller.decorator';
import { PostHitsQuery } from './post.hist.query.dto';

@ApiTags('Post')
@ApiBearerAuth('access-token')
@RestController('post')
export class PostController {
  constructor(private readonly postService: PostService) {}

  @ApiOperation({ description: '인기 게시글을 반환합니다.' })
  @ApiResponse({ type: [PostFindResponse] })
  @ApiQuery({ type: PostHitsQuery })
  @Get('hits')
  async default(query: PostHitsQuery) {
    return await this.postService.popularList(query);
  }

  @ApiResponse({ description: '리스트 조회', type: [PostFindResponse] })
  @ApiQuery({ description: '제목 검색', type: PostFindQuery })
  @Get('find')
  async find(@Query() query: PostFindQuery) {
    return await this.postService.search(query);
  }

  @ApiResponse({ description: '상세 조회', type: PostReadResponse })
  @ApiQuery({ description: '게시글 id' })
  @Get('detail')
  async detail(@Query('id') id: number) {
    return plainToInstance(PostReadResponse, await this.postService.detail(id));
  }

  @ApiBody({ description: '업로드', type: PostWriteBody })
  @Post('upload')
  async upload(@Body() post: PostWriteBody) {
    // return plainToInstance(PostWriteBody, await this.postService.upload(post));
    await this.postService.upload(post);
  }

  @ApiOperation({ description: '게시글 좋아요' })
  @ApiQuery({ description: '게시글 id' })
  @Patch('like')
  async like(
    @Query('id') id: number,
    @AuthenticatedUser() user: Authentication,
  ) {
    await this.postService.like(user.email, id);
  }
}
