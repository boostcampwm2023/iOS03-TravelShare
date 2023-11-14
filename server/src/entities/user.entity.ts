import {
  Column,
  Entity,
  JoinTable,
  ManyToMany,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Post } from './post.entity';

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

  @Column()
  profile: string;

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
}
