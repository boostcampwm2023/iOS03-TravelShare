import { ApiProperty } from "@nestjs/swagger";
import { IsEmail } from "class-validator";


export class UserFollowQuery {
    @ApiProperty({description: '팔로잉 누른 사람', type: 'email'})
    @IsEmail()
    follower: string;
}