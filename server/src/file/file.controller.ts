import {
  Controller,
  Get,
  Headers,
  Param,
  Post,
  RawBodyRequest,
  Req,
  StreamableFile,
} from '@nestjs/common';
import { FileService } from './file.service';
import { Request } from 'express';
import { Public } from 'src/auth/auth.decorators';
import { ApiProperty } from '@nestjs/swagger';

@Controller('file')
@Public()
export class FileController {
  constructor(private fileService: FileService) {}

  @ApiProperty()
  @Post('put')
  async upload(@Req() req: RawBodyRequest<Request>) {
    return await this.fileService.uploadFile(req.rawBody, 'macro-storage');
  }

  @Get('get/:key')
  async download(@Param('key') key: string) {
    return new StreamableFile(
      await this.fileService.downloadFile(key, 'macro-storage'),
    );
  }
}
