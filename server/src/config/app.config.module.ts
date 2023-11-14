import { Global, Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import appConfig from "./app.config";

@Global()
@Module({
    imports: [ConfigModule.forRoot({load: [appConfig], isGlobal: true})]
})
export class AppConfigModule {}