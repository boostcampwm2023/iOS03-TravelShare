import { Equals, IsString } from 'class-validator';

export class AppleIdentityTokenHeader {
  @Equals('RS256')
  alg: string;

  @IsString()
  kid: string;
}
