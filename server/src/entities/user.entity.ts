import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  Index,
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
  @Index({ fulltext: true, parser: 'ngram' })
  name: string;

  @Column()
  password: string;

  @Column({ name: 'image_url', nullable: true })
  imageUrl: string;

  @Column('enum', { default: 'user', enum: ['user', 'admin'] })
  role: UserRole;

  @Column({ nullable: true })
  introduce: string;

  @ManyToMany(() => User, ({ followees }) => followees)
  @JoinTable({
    name: 'user_followers_relation',
    joinColumn: { name: 'followee_email', referencedColumnName: 'email' },
    inverseJoinColumn: {
      name: 'follower_email',
      referencedColumnName: 'email',
    },
  })
  followers: User[];

  @ManyToMany(() => User, ({ followers }) => followers, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  followees: User[];

  @Column('int', { name: 'followers_num', default: 0 })
  followersNum: number;

  @Column('int', { name: 'followees_num', default: 0 })
  followeesNum: number;

  @ManyToMany(() => Post, ({ likedUsers }) => likedUsers, {
    onDelete: 'CASCADE',
  })
  likedPosts: Post[];

  @OneToMany(() => Post, ({ writer }) => writer)
  writedPosts: Post[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'modified_at' })
  modifiedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: Date;
}
