import { Type } from 'class-transformer';
import {
  IsArray,
  IsNumber,
  IsObject,
  IsString,
  ValidateNested,
} from 'class-validator';

class Confidence {
  @IsNumber()
  negative: number;
  @IsNumber()
  positive: number;
  @IsNumber()
  neutral: number;
}

class Sentence {
  @IsString()
  content: string;
  @IsNumber()
  offset: number;
  @IsNumber()
  length: number;
  @IsString()
  sentiment: string;
  @IsObject()
  @ValidateNested()
  @Type(() => Confidence)
  confidence: Confidence;
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => Highlight)
  highlights: Highlight[];
}

class Highlight {
  @IsNumber()
  offset: number;
  @IsNumber()
  length: number;
}

class Document {
  @IsString()
  sentiment: string;
  @IsObject()
  @ValidateNested()
  @Type(() => Confidence)
  confidence: Confidence;
}

export class SentimentAnalysisResponse {
  @IsObject()
  @ValidateNested()
  @Type(() => Document)
  document: Document;
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => Sentence)
  sentences: Sentence[];
}
