import { Global, Module } from '@nestjs/common';
import { KaKaoMapController } from './map.kakao.controller';
import { KakaoMapService } from './map.kakao.service';
import { MapController } from './map.controller';
import { MapService } from './map.service';

@Global()
@Module({
  controllers: [MapController, KaKaoMapController],
  providers: [MapService, KakaoMapService],
})
export class MapModule {}
