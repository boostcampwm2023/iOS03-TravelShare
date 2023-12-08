import { Post, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { RestController } from 'utils/rest.controller.decorator';
import { ReportPostQuery } from './report.post.query.dto';
import { AuthenticatedUser } from 'auth/auth.decorators';
import { Authentication } from 'auth/authentication.dto';
import { ReportService } from './report.service';

@ApiTags('report')
@ApiBearerAuth('access-token')
@RestController('report')
export class ReportController {
  constructor(private readonly reportService: ReportService) {}

  @ApiOperation({
    summary: '신고',
  })
  @Post('post')
  async badpost(
    @Query() query: ReportPostQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    await this.reportService.isBadPost(query, user);
  }
}
