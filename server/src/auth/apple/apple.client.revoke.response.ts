import { IsNumber, IsString } from 'class-validator';

export class AppleClientRevokeResponse {
  @IsNumber()
  statusCode: number = 200;
  @IsString()
  message: string = 'OK';
}
