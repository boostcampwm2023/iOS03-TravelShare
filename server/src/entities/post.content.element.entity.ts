import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Post } from './post.entity';

const POINT_COORDINATES_EXTRACT_REGEXP = /POINT\(([\d\.]+ [\d\.]+)\)/;

export type Coordinate = {
  x: number;
  y: number;
};

export const pointToJsonObject = (text?: string) => {
  if (!text) {
    return null;
  }
  const [y, x] = POINT_COORDINATES_EXTRACT_REGEXP.exec(text)?.[1]
    .split(/\s/)
    .map(parseFloat) as [number, number];

  return { x, y } as Coordinate;
};

export const jsonToPoint = (coordinate?: Coordinate) => {
  if (!coordinate) {
    return null;
  }
  const { x, y } = coordinate;
  return `POINT(${y} ${x})`;
};

@Entity('post_content_element')
export class PostContentElement {
  @PrimaryGeneratedColumn({ name: 'post_content_element_id' })
  postContentElemntId?: number;

  @ManyToOne(() => Post, ({ contents }) => contents, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'post_id' })
  post: Post;

  @Column({ name: 'image_url' })
  imageUrl: string;

  @Column({ nullable: true })
  @Index({ fulltext: true, parser: 'ngram' })
  description: string;

  @Column('geometry', {
    spatialFeatureType: 'Point',
    srid: 4326,
    transformer: {
      from: pointToJsonObject,
      to: jsonToPoint,
    },
    nullable: true,
  })
  coordinate: Coordinate;
}
