import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  Coordinate,
  jsonToPoint,
  pointToJsonObject,
} from './post.content.element.entity';
import { IsNumberString, IsPhoneNumber, IsString } from 'class-validator';

@Entity('place')
export class Place {
  @PrimaryColumn({ name: 'placa_id' })
  @IsNumberString()
  placeId: string;

  @Column({ name: 'place_name' })
  @IsString()
  placeName: string;

  @Column({ name: 'phone_number' })
  @IsPhoneNumber()
  phoneNumber: string;

  @Column()
  @IsString()
  category: string;

  @Column()
  @IsString()
  address: string;

  @Column({ name: 'road_address' })
  @IsString()
  roadAddress: string;

  @Column('geometry', {
    spatialFeatureType: 'Point',
    srid: 4326,
    transformer: {
      from: pointToJsonObject,
      to: jsonToPoint,
    },
  })
  coordinate: Coordinate;
}
