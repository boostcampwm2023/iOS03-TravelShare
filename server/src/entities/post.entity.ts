import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  JoinColumn,
  JoinTable,
  ManyToMany,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from './user.entity';
import { Route } from './route.entity';

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

  @Column('json')
  hashtag: string[];

  @Column('date', { name: 'start_at' })
  startAt: Date;

  @Column('date', { name: 'end_at' })
  endAt: Date;

  @ManyToMany(() => User, (user) => user.likedPosts)
  @JoinTable({
    name: 'post_likes_users',
    joinColumn: { name: 'post_id' },
    inverseJoinColumn: { name: 'email', referencedColumnName: 'email' },
  })
  likedUsers: User[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'modified_at' })
  modifiedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: Date;
}

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

  @Column()
  x: number;

  @Column()
  y: number;
}
