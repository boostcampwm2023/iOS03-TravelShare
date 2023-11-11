import { Body, Controller, Get, Patch, Post, Query } from '@nestjs/common';
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

@ApiBearerAuth('access-token')
@Controller('post')
export class PostController {
  @ApiResponse({ description: '리스트 조회', type: [PostFindResponse] })
  @ApiQuery({ description: '' })
  @Get('find')
  async find(@Query() query: PostFindQuery) {}

  @ApiResponse({ description: '상세 조회', type: PostReadResponse })
  @ApiQuery({ description: '게시글 id' })
  @Get('detail')
  async detail(@Query('id') id: number) {}

  @ApiBody({ description: '업로드', type: PostWriteBody })
  @Post('upload')
  async upload(@Body() post: PostWriteBody) {}

  @ApiOperation({ description: '게시글 좋아요' })
  @ApiQuery({ description: '게시글 id' })
  @Patch('like')
  async like(@Query('id') id: number) {}

  @ApiOperation({ description: '게시글 좋아요 취소' })
  @ApiQuery({ description: '게시글 id' })
  @Patch('unlike')
  async unlike(@Query('id') id: number) {}
}