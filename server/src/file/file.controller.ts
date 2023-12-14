import { Headers, Put, Req } from '@nestjs/common';
import { FileService } from './file.service';
import { Request } from 'express';
import { Public } from 'auth/auth.decorators';
import {
  ApiHeaders,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { RestController } from 'utils/rest.controller.decorator';
import { FileUploadResponse } from './file.upload.response.dto';

@ApiTags('image')
@RestController('file')
@Public()
export class FileController {
  constructor(private fileService: FileService) {}

  @ApiOperation({
    summary:
      '이미지를 업로드하고 이미지 id를 반환받습니다. Content-Length, Content-Type이 명시되어야 합니다.',
  })
  @ApiResponse({ type: FileUploadResponse })
  @ApiHeaders([
    {
      name: 'Content-Length',
      example: 325,
      description: `파일의 길이를 반드시 보내야 합니다. 안그러면 파일 업로드가 제대로 작동하지 않습니다.`,
    },
    {
      name: 'Content-Type',
      examples: {
        generic: {
          value: 'image/*',
        },
        jpeg: {
          value: 'image/jpeg',
        },
        png: {
          value: 'image/png',
        },
      },
    },
  ])
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
      bucket: 'macro-bucket',
    });
  }
}
