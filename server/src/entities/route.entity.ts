import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  PrimaryGeneratedColumn,
} from 'typeorm';

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
