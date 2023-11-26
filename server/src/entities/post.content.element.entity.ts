import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Post } from './post.entity';

const POINT_COORDINATES_EXTRACT_REGEXP = /POINT\(([\d\.]+ [\d\.]+)\)/;

type Coordinate = {
  x: number;
  y: number;
};

const pointToJsonObject = (text: string) => {
  const [y, x] = POINT_COORDINATES_EXTRACT_REGEXP.exec(text)?.[1]
    .split(/\s/)
    .map(parseFloat) as [number, number];

  return { x, y } as Coordinate;
};

const jsonToPoint = ({ x, y }: Coordinate) => {
  return `POINT(${y} ${x})`;
};

@Entity('post_content_element')
export class PostContentElement {
  @PrimaryGeneratedColumn({ name: 'post_content_element_id' })
  postContentElemntId?: number;

  @ManyToOne(() => Post, ({ contents }) => contents)
  @JoinColumn({ name: 'post_id' })
  post: Post;

  @Column({ name: 'image_url', nullable: true })
  imageUrl: string;

  @Column()
  description: string;

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
