import { ConfigService } from '@nestjs/config';
import { S3 } from 'aws-sdk';

const AwsS3ProviderFactory = (configService: ConfigService) => {
  return new S3(configService.get('object-storage.options'));
};

export { AwsS3ProviderFactory };
