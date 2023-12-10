import { Column, Entity, ManyToMany, PrimaryColumn } from 'typeorm';
import {
  Coordinate,
  jsonToPoint,
  pointToJsonObject,
} from './post.content.element.entity';
import { Post } from './post.entity';

@Entity('place')
export class Place {
  @PrimaryColumn({ name: 'place_id' })
  placeId: string;

  @Column({ name: 'place_name' })
  placeName: string;

  @Column({ name: 'phone_number', nullable: true })
  phoneNumber: string;

  @Column()
  category: string;

  @Column()
  address: string;

  @Column({ name: 'road_address', nullable: true })
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

  @ManyToMany(() => Post, ({ pins }) => pins, { onDelete: 'CASCADE' })
  posts: Post[];
}
