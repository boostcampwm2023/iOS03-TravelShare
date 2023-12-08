import { ConflictException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Report } from 'entities/report.entity';
import { Repository } from 'typeorm';
import { ReportPostQuery } from './report.post.query.dto';
import { Authentication } from 'auth/authentication.dto';

@Injectable()
export class ReportService {
  constructor(
    @InjectRepository(Report)
    private readonly reportRepository: Repository<Report>,
  ) {}

  async isBadPost({ postId }: ReportPostQuery, { email }: Authentication) {
    await this.reportRepository
      .save({ post: { postId }, from: { email } })
      .catch((err) => {
        throw new ConflictException('already reported', { cause: err });
      });
  }
}
