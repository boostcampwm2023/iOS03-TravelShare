import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  JoinTable,
  ManyToMany,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Post } from './post.entity';

export type UserRole = 'user' | 'admin';

@Entity('user')
export class User {
  @PrimaryGeneratedColumn('uuid', { name: 'user_id' })
  userId: string;

  @Column({ unique: true })
  email: string;

  @Column()
  name: string;

  @Column()
  password: string;

  @Column({ name: 'image_url', nullable: true })
  imageUrl: string;

  @Column('enum', { default: 'user', enum: ['user', 'admin'] })
  role: UserRole;

  @ManyToMany(() => User, (user) => user.followings)
  @JoinTable({
    name: 'user_followers_relation',
    joinColumn: { name: 'follower_id' },
    inverseJoinColumn: { name: 'followee_id' },
  })
  followers: User[];

  @ManyToMany(() => User, (user) => user.followers)
  // @JoinTable({
  //   name: 'user_followers_relation',
  //   joinColumn: { name: 'followee_id' },
  //   inverseJoinColumn: { name: 'follower_id' },
  // })
  followings: User[];

  @ManyToMany(() => Post, ({ likedUsers }) => likedUsers)
  likedPosts: Post[];

  @OneToMany(() => Post, (post) => post.writer)
  writedPosts: Post[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'modified_at' })
  modifiedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: Date;
}
