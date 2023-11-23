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

  @ManyToOne(() => User, (user) => user.email, {
    cascade: ['remove', 'soft-remove', 'update', 'recover'],
  })
  @JoinColumn({ name: 'user_id' })
  writer: User;

  @Column()
  title: string;

  @OneToMany(() => PostContentElement, (post) => post.post, {
    cascade: ['insert', 'soft-remove', 'update'],
  })
  contents: PostContentElement[];

  @Column({ name: 'view_num', default: 0 })
  viewNum: number;

  @Column({ name: 'like_num', default: 0 })
  likeNum: number;

  @Column({ nullable: true })
  summary: string;

  @Column('json')
  route: [number, number][];

  @Column('json', { default: null })
  hashtag: string[];

  @Column('date', { name: 'start_at' })
  startAt: Date;

  @Column('date', { name: 'end_at' })
  endAt: Date;

  @ManyToMany(() => User, (user) => user.email)
  @JoinTable({
    name: 'post_likes_users',
    joinColumn: { name: 'post_id' },
    inverseJoinColumn: { name: 'email' },
  })
  likeUsers: User[];

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

  @Column({ name: 'image_url', nullable: true })
  imageUrl: string;

  @Column()
  description: string;

  @Column()
  x: number;

  @Column()
  y: number;
}
