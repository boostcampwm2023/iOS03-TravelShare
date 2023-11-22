import { Inject, Injectable, Scope } from '@nestjs/common';
import { S3 } from 'aws-sdk';
import { S3_PROVIDER } from './file.constants';
import { randomUUID } from 'crypto';

@Injectable()
export class FileService {
  constructor(@Inject(S3_PROVIDER) private readonly s3: S3) {}

  async uploadFile(data: Buffer, bucket: string) {
    const key = randomUUID();
    await this.s3
      .putObject({
        Bucket: bucket,
        Key: key,
        Body: data,
      })
      .promise();
    return key;
  }

  async downloadFile(key: string, bucket: string) {
    this.s3.getObject;
    return this.s3
      .getObject({
        Bucket: bucket,
        Key: key,
      })
      .createReadStream();
  }
}
