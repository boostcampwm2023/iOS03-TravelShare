import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  Index,
  JoinColumn,
  JoinTable,
  ManyToMany,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
  VirtualColumn,
} from 'typeorm';
import { User } from './user.entity';
import { Route } from './route.entity';
import { PostContentElement } from './post.content.element.entity';
import { Place } from './place.entity';

@Entity('post')
export class Post {
  @PrimaryGeneratedColumn({ name: 'post_id' })
  postId: number;

  @ManyToOne(() => User, ({ writedPosts }) => writedPosts, {
    cascade: ['remove', 'soft-remove', 'update', 'recover'],
  })
  @JoinColumn({ name: 'user_email', referencedColumnName: 'email' })
  writer: User;

  @Column()
  @Index({ fulltext: true, parser: 'ngram' })
  title: string;

  @OneToMany(() => PostContentElement, ({ post }) => post, {
    cascade: ['insert', 'soft-remove', 'update'],
  })
  contents: PostContentElement[];

  @Column({ name: 'view_num', default: 0 })
  viewNum: number;

  @Column({ name: 'like_num', default: 0 })
  likeNum: number;

  @Column({ nullable: true })
  summary: string;

  @OneToOne(() => Route)
  @JoinColumn({ name: 'route_id', referencedColumnName: 'routeId' })
  route: Route;

  @VirtualColumn({
    query: (alias) =>
      `
    SELECT \`contents\`.\`image_url\` as \`imageUrl\`
    FROM \`post_content_element\` \`contents\`
    WHERE (\`contents\`.\`post_id\`=${alias}.\`post_id\`)
    AND (\`contents\`.\`image_url\` IS NOT NULL)
    LIMIT 1
    `,
  })
  imageUrl: string;

  @Column('date', { name: 'start_at' })
  startAt: Date;

  @Column('date', { name: 'end_at' })
  endAt: Date;

  @ManyToMany(() => User, ({ likedPosts }) => likedPosts)
  @JoinTable({
    name: 'post_likes_users',
    joinColumn: { name: 'post_id' },
    inverseJoinColumn: { name: 'email', referencedColumnName: 'email' },
  })
  likedUsers: User[];

  @Column({ default: true })
  public: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'modified_at' })
  modifiedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: Date;

  @ManyToMany(() => Place, ({ posts }) => posts)
  @JoinTable({
    name: 'pins',
    joinColumn: { name: 'post_id' },
    inverseJoinColumn: { name: 'place_id', referencedColumnName: 'placeId' },
  })
  pins: Place[];
}
