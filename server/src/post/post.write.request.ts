import { ApiProperty } from "@nestjs/swagger";
import { Type } from "class-transformer";
import { IsArray, IsNumber, IsString, IsUrl, ValidateNested } from "class-validator";

class PostWriteElement {
    @ApiProperty({description: '이미지 url'})
    @IsUrl()
    imageUrl: string;

    @ApiProperty({description: '설명'})
    @IsString()
    description: string;

    @ApiProperty({description: 'x 좌표'})
    @IsNumber()
    positionX: number;

    @ApiProperty({description: 'y 좌표'})
    @IsNumber()
    positionY: number;
}

export class PostWriteRequest {
    @ApiProperty({description: '제목'})
    @IsString()
    title: string;

    @ApiProperty({description: '사진과 글', type: [PostWriteElement]})
    @IsArray()
    @ValidateNested()
    @Type(()=> PostWriteElement)
    elements: PostWriteElement[]
}