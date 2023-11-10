import { Controller, Get, Post, Query } from "@nestjs/common";
import { ApiBearerAuth, ApiBody, ApiHeader, ApiQuery, ApiResponse } from "@nestjs/swagger";
import { PostFindResponse } from "./post.find.response";
import { PostReadResponse } from "./post.read.response";
import { PostWriteRequest } from "./post.write.request";

@ApiHeader({name: 'Authorization', description: 'JWT', schema: {type: 'JWT'}})
@Controller('post')
export class PostController {

    @ApiResponse({description: '리스트 조회', type: [PostFindResponse]})
    @Get('find')
    async find() {}

    @ApiResponse({description: '상세 조회', type: PostReadResponse})
    @ApiQuery({description: '게시글 id'})
    @Get('detail')
    async detail(@Query('id') id: number) {}

    @ApiBody({description: '업로드', type: PostWriteRequest})
    @Post('upload')
    async upload() {}
}