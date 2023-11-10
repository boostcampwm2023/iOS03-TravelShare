import { Controller, Get, Post, Query } from "@nestjs/common";
import { ApiBearerAuth, ApiBody, ApiQuery, ApiResponse } from "@nestjs/swagger";
import { PostFindResponse } from "./post.find.response.dto";
import { PostReadResponse } from "./post.read.response.dto";
import { PostWriteBody } from "./post.write.request";
import { PostFindQuery } from "./post.find.query.dto";

@ApiBearerAuth('access-token')
@Controller('post')
export class PostController {

    @ApiResponse({description: '리스트 조회', type: [PostFindResponse]})
    @ApiQuery({description: ''})
    @Get('find')
    async find(@Query() query: PostFindQuery) {}

    @ApiResponse({description: '상세 조회', type: PostReadResponse})
    @ApiQuery({description: '게시글 id'})
    @Get('detail')
    async detail(@Query('id') id: number) {}

    @ApiBody({description: '업로드', type: PostWriteBody})
    @Post('upload')
    async upload() {}
}