import {
  Column,
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from './user.entity';
import { Post } from './post.entity';

@Entity('report')
export class Report {
  @PrimaryGeneratedColumn()
  reportId: number;

  @ManyToOne(() => Post, { onDelete: 'NO ACTION' })
  @JoinColumn({
    name: 'post_id',
  })
  post: Post;

  @ManyToOne(() => User, { onDelete: 'NO ACTION' })
  @JoinColumn({
    name: 'user_email',
    referencedColumnName: 'email',
  })
  from: User;

  @Column({ nullable: true })
  title: string;

  @Column({ nullable: true })
  description: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  modifiedAt: Date;

  @DeleteDateColumn()
  deletedAt: Date;
}
