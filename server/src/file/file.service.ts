import { Inject, Injectable } from '@nestjs/common';
import { S3 } from 'aws-sdk';
import { S3_PROVIDER } from './file.constants';
import { randomUUID } from 'crypto';
import { ConfigService } from '@nestjs/config';
import { plainToInstance } from 'class-transformer';
import { FileUploadResponse } from './file.upload.response.dto';

@Injectable()
export class FileService {
  constructor(
    @Inject(S3_PROVIDER) private readonly s3: S3,
    private readonly configService: ConfigService,
  ) {}

  async uploadFile({ file, type, length, bucket }) {
    const key = this.getRandomEncodedKey();
    const { ETag } = await this.s3
      .putObject({
        Bucket: bucket,
        Key: key,
        Body: file,
        ContentType: type,
        ContentLength: length,
        ACL: 'public-read',
      })
      .promise();
    return plainToInstance(FileUploadResponse, {
      url: `${this.configService.get(
        'object-storage.options.endpoint',
      )}/${bucket}/${key}`,
      etag: ETag,
    });
  }

  async downloadFile(key: string, bucket: string) {
    this.s3.getObject;
    return this.s3
      .getObject({
        Bucket: bucket,
        Key: encodeURI(key),
      })
      .createReadStream();
  }

  private getRandomEncodedKey() {
    return encodeURI(`static/image/boostcampmacro-${randomUUID()}`);
  }
}
