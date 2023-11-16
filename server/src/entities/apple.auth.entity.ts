import { Entity, JoinColumn, OneToOne, PrimaryColumn } from 'typeorm';
import { User } from './user.entity';

@Entity('apple_auth')
export class AppleAuth {
  @PrimaryColumn({ name: 'apple_id' })
  appleId: string;

  @OneToOne(() => User)
  @JoinColumn({
    name: 'user_id',
  })
  user: User;
}
