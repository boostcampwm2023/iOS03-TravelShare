import {
  Body,
  Controller,
  Get,
  HttpStatus,
  Patch,
  Post,
  Query,
  Response,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiQuery,
  ApiResponse,
} from '@nestjs/swagger';
import { PostFindResponse } from './post.find.response.dto';
import { PostReadResponse } from './post.read.response.dto';
import { PostWriteBody } from './post.write.body';
import { PostFindQuery } from './post.find.query.dto';
import { plainToInstance } from 'class-transformer';
import { PostService } from './post.service';
import { AuthenticatedUser } from 'src/auth/auth.decorators';
import { AuthUser } from 'src/auth/authentication.dto';
import { Response as HttpResponse } from 'express';

@ApiBearerAuth('access-token')
@Controller('post')
export class PostController {
  constructor(private readonly postService: PostService) {}

  @ApiResponse({ description: '리스트 조회', type: [PostFindResponse] })
  @ApiQuery({ description: '' })
  @Get('find')
  async find(@Query() query: PostFindQuery) {}

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
    return {};
  }

  @ApiOperation({ description: '게시글 좋아요' })
  @ApiQuery({ description: '게시글 id' })
  @Patch('like')
  async like(
    @Query('id') id: number,
    @AuthenticatedUser() user: AuthUser,
    @Response() res: HttpResponse,
  ) {
    await this.postService.like(user.email, id);
    res.status(HttpStatus.OK).end();
  }

  @ApiOperation({ description: '게시글 좋아요 취소' })
  @ApiQuery({ description: '게시글 id' })
  @Patch('unlike')
  async unlike(
    @Query('id') id: number,
    @AuthenticatedUser() user: AuthUser,
    @Response() res: HttpResponse,
  ) {
    await this.postService.unlike(user.email, id);
  }
}
