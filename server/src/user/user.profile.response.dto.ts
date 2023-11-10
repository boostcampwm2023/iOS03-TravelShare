import { ApiProperty } from "@nestjs/swagger";
import { IsEmail, IsOptional, IsString, IsUrl } from "class-validator";


export class UserProfileResponse {
    @ApiProperty({description: '작성자 email'})
    @IsEmail()
    id: string;

    @ApiProperty({description: '작성자 이름'})
    @IsString()
    name: string;

    @ApiProperty({description: '프로필 사진 url', required: false})
    @IsUrl()
    @IsOptional()
    imageUrl?: string;

    @ApiProperty({description: '자기소개', required: false})
    @IsString()
    @IsOptional()
    introduce?: string;
}