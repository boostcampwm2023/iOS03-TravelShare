import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  JoinTable,
  ManyToMany,
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

  @Column({ nullable: true })
  profile: string;

  @Column('enum', { default: 'user', enum: ['user', 'admin'] })
  role: UserRole;

  @ManyToMany(() => User, (user) => user.email)
  @JoinTable({
    name: 'user_followers_relation',
    joinColumn: { name: 'follower_id' },
    inverseJoinColumn: { name: 'followee_id' },
  })
  followers: Promise<User[]>;

  @ManyToMany(() => User, (user) => user.email)
  @JoinTable({
    name: 'user_followers_relation',
    joinColumn: { name: 'followee_id' },
    inverseJoinColumn: { name: 'follower_id' },
  })
  followings: Promise<User[]>;

  @ManyToMany(() => Post)
  @JoinTable({ name: 'post_ssss' })
  likedPosts: Post[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'modified_at' })
  modifiedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: Date;
}
