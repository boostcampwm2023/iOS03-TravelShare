import { HttpService } from "@nestjs/axios";
import { Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { MapSearchResponse } from "./map.search.response.dto";
import { map } from "rxjs";
const displayNum=5;

@Injectable()
export class MapService {
    constructor(
        private readonly httpService: HttpService,
        private readonly configService: ConfigService
    ) {}

    async search(keyword: string) {
        return await this.httpService.get(
            this.configService.get('naver.search.url') + encodeURI(`?query=${keyword}&display=${displayNum}`),
            {
                headers: this.configService.get('naver.search.headers')
            }
        )
        .pipe(
            map((res, index)=> {
                const body =  res.data                
                return body.items.map(v=> {
                    return {
                        ...v, mapx: parseFloat(v.mapx) / 10000000, mapy: parseFloat(v.mapy) / 10000000
                    }
                })
            })
        )
    }
}