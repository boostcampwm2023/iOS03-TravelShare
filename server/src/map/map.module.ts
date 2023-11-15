import { Global, Module } from '@nestjs/common';
import { MapController } from './map.controller';
import { MapService } from './map.service';

@Global()
@Module({
  controllers: [MapController],
  providers: [MapService],
})
export class MapModule {}
