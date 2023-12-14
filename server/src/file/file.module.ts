import { Module } from '@nestjs/common';
import { AwsS3ProviderFactory } from './s3.provider.factory';
import { ConfigService } from '@nestjs/config';
import { S3_PROVIDER } from './file.constants';
import { FileService } from './file.service';
import { FileController } from './file.controller';

@Module({
  controllers: [FileController],
  providers: [
    {
      provide: S3_PROVIDER,
      inject: [ConfigService],
      useFactory: AwsS3ProviderFactory,
    },
    FileService,
  ],
})
export class FileModule {}
