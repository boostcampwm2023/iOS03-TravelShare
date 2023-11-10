import { ApiProperty } from "@nestjs/swagger";
import { IsEmail, IsString, IsUrl } from "class-validator";


export class UserSimpleResponse {
    @ApiProperty({description: '작성자 email'})
    @IsEmail()
    email: string;

    @ApiProperty({description: '작성자 이름'})
    @IsString()
    name: string;

    @ApiProperty({description: '프로필 사진 url'})
    @IsUrl()
    imageUrl: string;
}