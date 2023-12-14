import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  JoinColumn,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Post } from './post.entity';

const LINESTRING_COORDINATES_EXTRACT_REGEXP =
  /LINESTRING\(((\-?[\d\.]+ \-?[\d\.]+,?)+)\)/;

export type LineString = { x: number; y: number }[];

const lineStringToJsonArray = (text?: string) => {
  const extracted = LINESTRING_COORDINATES_EXTRACT_REGEXP.exec(text)?.[1];
  if (!text) {
    return null;
  }
  return extracted
    .split(',')
    .map((coordinate) => coordinate.split(/\s+/).map(parseFloat))
    .map(([lat, long]) => ({ x: long, y: lat }));
};

const jsonArrayToLineString = (coordinates: LineString) => {
  return `LINESTRING(${coordinates.map(({ x, y }) => `${y} ${x}`).join(',')})`;
};

@Entity('route')
export class Route {
  @PrimaryGeneratedColumn({ name: 'route_id' })
  routeId: number;

  @OneToOne(() => Post, (post) => post.route, { onDelete: 'CASCADE' })
  @JoinColumn({
    name: 'post_id',
  })
  post: Post;

  @Column('geometry', {
    spatialFeatureType: 'LineString',
    srid: 4326,
    transformer: {
      from: lineStringToJsonArray,
      to: jsonArrayToLineString,
    },
  })
  @Index({ spatial: true })
  coordinates: LineString;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}
