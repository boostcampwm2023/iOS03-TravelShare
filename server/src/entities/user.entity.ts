import { Column, Entity, JoinTable, ManyToMany, PrimaryColumn } from 'typeorm';
import { Post } from './post.entity';

@Entity('user')
export class User {
  @PrimaryColumn({ name: 'user_id' })
  userId: string;

  @Column()
  username: string;

  @Column()
  password: string;

  @Column()
  profile: string;

  @ManyToMany(() => User)
  @JoinTable({ name: 'user_followers' })
  followers: Promise<User[]>;

  @ManyToMany(() => Post)
  @JoinTable({ name: 'post_ssss' })
  likedPosts: Post[];
}
