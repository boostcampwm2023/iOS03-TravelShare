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
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from './user.entity';

@Entity('post')
export class Post {
  @PrimaryGeneratedColumn({ name: 'post_id' })
  postId: number;

  @ManyToOne(() => User, (user) => user.email)
  @JoinColumn({ name: 'user_email' })
  writer: User;

  @Column()
  title: string;

  @OneToMany(() => PostContentElement, (post) => post.post, {
    cascade: ['insert', 'soft-remove', 'update'],
    lazy: true,
  })
  contents: PostContentElement[];

  @Column({ name: 'view_num', default: 0 })
  viewNum: number;

  @Column({ name: 'like_num', default: 0 })
  likeNum: number;

  @Column({ nullable: true })
  summary: string;

  // @Column('json')
  // route: string[];

  // @Column('json', { default: null })
  // hashtag: string[];

  @Column('date', { name: 'start_at' })
  startAt: Date;

  @Column('date', { name: 'end_at' })
  endAt: Date;

  @ManyToMany(() => User, (user) => user.email)
  @JoinTable({
    joinColumn: { name: 'post_id' },
    inverseJoinColumn: { name: 'user_email' },
  })
  likeUsers: Promise<User[]>;

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

  @ManyToOne(() => Post)
  @JoinColumn({ name: 'post_id' })
  post: Post;

  @Column({ name: 'image_url' })
  imageUrl: string;

  @Column()
  description: string;

  @Column()
  mapx: number;

  @Column()
  mapy: number;
}
