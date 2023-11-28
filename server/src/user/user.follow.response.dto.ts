import { ApiProperty } from "@nestjs/swagger";
import { Type } from "class-transformer";
import { IsEmail, IsInt, Min, ValidateNested } from "class-validator";

export class UserFollowState {
    @ApiProperty({description: '유저 이메일'})
    @IsEmail()
    email: string;

    @ApiProperty({description: '팔로워 숫자'})
    @IsInt()
    @Min(0)
    followersNum: number;

    @ApiProperty({description: '팔로잉 숫자'})
    @IsInt()
    @Min(0)
    followeesNum: number;
}

export class UserFollowResponse {
    @ApiProperty({description: '팔로잉'})
    @ValidateNested()
    @Type(()=> UserFollowState)
    followee: UserFollowState;

    @ApiProperty({description: '팔로워'})
    @ValidateNested()
    @Type(()=> UserFollowState)
    follower: UserFollowState;
}