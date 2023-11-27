import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Route } from 'entities/route.entity';
import { Repository } from 'typeorm';
import { RouteUploadBody } from './route.upload.body.dto';
import { plainToInstance } from 'class-transformer';
import { RouteUploadResponse } from './route.upload.response.dto';

@Injectable()
export class RouteService {
  constructor(
    @InjectRepository(Route)
    private readonly routeRepository: Repository<Route>,
  ) {}

  async upload({ coordinates }: RouteUploadBody) {
    const route = await this.routeRepository.create({ coordinates });
    const { routeId } = await this.routeRepository.save(route);
    return plainToInstance(RouteUploadResponse, { routeId });
  }
}
