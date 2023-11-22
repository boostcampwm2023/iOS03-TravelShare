import { Headers, Put, Req } from '@nestjs/common';
import { FileService } from './file.service';
import { Request } from 'express';
import { Public } from 'src/auth/auth.decorators';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { RestController } from 'src/utils/rest.controller.decorator';
import { FileUploadResponse } from './file.upload.response.dto';

@ApiTags('Image')
@RestController('file')
@Public()
export class FileController {
  constructor(private fileService: FileService) {}

  @ApiOperation({
    description:
      '이미지를 업로드하고 이미지 id를 반환받습니다. Content-Length, Content-Type이 명시되어야 합니다.',
  })
  @ApiResponse({ type: FileUploadResponse })
  @Put('put')
  async upload(
    @Req() req: Request,
    @Headers('Content-Length') length: number,
    @Headers('Content-Type') type: string,
  ) {
    return await this.fileService.uploadFile({
      file: req,
      length,
      type,
      bucket: 'macro-storage',
    });
  }
}
