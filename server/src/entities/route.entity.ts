import {
  AfterLoad,
  BeforeInsert,
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
} from 'typeorm';

const LINESTRING_COORDINATES_EXTRACT_REGEXP =
  /LINESTRING\((([\d\.]+ [\d\.]+,?)+)\)/;

@Entity('route')
export class Route {
  @PrimaryGeneratedColumn({ name: 'route_id' })
  routeId: number;

  @Column('geometry', { spatialFeatureType: 'LineString' })
  coordinates: any;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @BeforeInsert()
  serializeRoute() {
    this.coordinates = `LINESTRING(${this.coordinates
      .map(([x, y]) => `${x} ${y}`)
      .join(',')})`;
  }

  @AfterLoad()
  deserializeRoute() {
    const extract = LINESTRING_COORDINATES_EXTRACT_REGEXP.exec(
      this.coordinates,
    )?.[1];
    this.coordinates = extract
      .split(',')
      .map((pair) => pair.trim().split(/\s+/).map(parseFloat));
  }
}
