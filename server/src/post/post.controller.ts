import { Body, Controller, Get, Patch, Post, Query } from '@nestjs/common';
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
import {
  PostFindMyLogQuery,
  PostFindOtherUserLogQuery,
  PostFindQuery,
  PostSearchKeywordQuery,
} from './post.find.query.dto';
import { plainToInstance } from 'class-transformer';
import { PostService } from './post.service';
import { AuthenticatedUser } from 'src/auth/auth.decorators';
import { Authentication } from 'src/auth/authentication.dto';

@ApiTags('Post')
@ApiBearerAuth('access-token')
@Controller('post')
export class PostController {
  constructor(private readonly postService: PostService) {}

  @ApiResponse({ description: '리스트 조회', type: [PostFindResponse] })
  @ApiQuery({ description: '키워드 검색', type: PostSearchKeywordQuery })
  @ApiQuery({ description: '기본(메인페이지)', type: PostFindMyLogQuery })
  @ApiQuery({
    description: '다른 유저 게시글',
    type: PostFindOtherUserLogQuery,
  })
  @Get('find')
  async find(
    @Query() query: PostFindQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    if ('keyword' in query) {
      return await this.postService.popularList(
        plainToInstance(PostSearchKeywordQuery, query),
      );
    } else if ('email' in query) {
      return await this.postService.findByUser(
        plainToInstance(PostFindOtherUserLogQuery, query),
      );
    } else {
      return await this.postService.findByUser(
        plainToInstance(PostFindOtherUserLogQuery, {
          ...query,
          email: user.email,
        }),
      );
    }
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

  @ApiOperation({ description: '게시글 좋아요 취소' })
  @ApiQuery({ description: '게시글 id' })
  @Patch('unlike')
  async unlike(
    @Query('id') id: number,
    @AuthenticatedUser() user: Authentication,
  ) {
    await this.postService.unlike(user.email, id);
  }
}
