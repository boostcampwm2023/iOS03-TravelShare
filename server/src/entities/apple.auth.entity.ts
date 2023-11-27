import {
  CreateDateColumn,
  DeleteDateColumn,
  Entity,
  JoinColumn,
  OneToOne,
  PrimaryColumn,
  Relation,
  UpdateDateColumn,
} from 'typeorm';
import { User } from './user.entity';

@Entity('apple_auth')
export class AppleAuth {
  @PrimaryColumn({ name: 'apple_id' })
  appleId: string;

  @OneToOne(() => User, { cascade: ['remove'] })
  @JoinColumn({
    name: 'user_id',
  })
  user: User;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'modified_at' })
  modifiedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at' })
  deletedAt: Date;
}
