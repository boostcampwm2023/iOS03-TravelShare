import { ApiProperty } from "@nestjs/swagger";
import { IsEmail, IsString, MaxLength, MinLength } from "class-validator";


export class UserSigninBody {
    @ApiProperty({description: 'id email'})
    @IsEmail()
    id: string;

    @ApiProperty({description: 'password'})
    @IsString()
    @MinLength(8)
    @MaxLength(50)
    password: string;
}