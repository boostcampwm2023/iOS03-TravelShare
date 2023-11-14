import { Global, Module } from "@nestjs/common";
import { MapController } from "./map.controller";
import { HttpModule } from "@nestjs/axios";
import { MapService } from "./map.service";

@Global()
@Module({
    imports: [HttpModule.register({timeout: 5000})],
    controllers: [MapController],
    providers: [MapService]
})
export class MapModule {}