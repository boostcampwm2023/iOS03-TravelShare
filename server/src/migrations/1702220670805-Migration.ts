import { MigrationInterface, QueryRunner } from 'typeorm';

export class Migration1702220670805 implements MigrationInterface {
  name = 'Migration1702220670805';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`post\` DROP FOREIGN KEY \`FK_1479c1e9196859565530ca7aa82\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\` DROP FOREIGN KEY \`FK_d95a0b4c2cd94d27476fbabbd33\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\` DROP FOREIGN KEY \`FK_53423b3b3071932f4c0e60cd4a5\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\` DROP FOREIGN KEY \`FK_e693278faea3d9d67f9f64fbb44\`
        `);
    await queryRunner.query(`
            DROP INDEX \`REL_1479c1e9196859565530ca7aa8\` ON \`post\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`route\`
            ADD \`post_id\` int NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`route\`
            ADD UNIQUE INDEX \`IDX_e4e867e5e97defcb3032b94aa0\` (\`post_id\`)
        `);
    await queryRunner.query(`
            CREATE UNIQUE INDEX \`REL_e4e867e5e97defcb3032b94aa0\` ON \`route\` (\`post_id\`)
        `);
    await queryRunner.query(`
            ALTER TABLE \`route\`
            ADD CONSTRAINT \`FK_e4e867e5e97defcb3032b94aa0c\` FOREIGN KEY (\`post_id\`) REFERENCES \`post\`(\`post_id\`) ON DELETE CASCADE ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\`
            ADD CONSTRAINT \`FK_d95a0b4c2cd94d27476fbabbd33\` FOREIGN KEY (\`email\`) REFERENCES \`user\`(\`email\`) ON DELETE CASCADE ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\`
            ADD CONSTRAINT \`FK_53423b3b3071932f4c0e60cd4a5\` FOREIGN KEY (\`place_id\`) REFERENCES \`place\`(\`place_id\`) ON DELETE CASCADE ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\`
            ADD CONSTRAINT \`FK_e693278faea3d9d67f9f64fbb44\` FOREIGN KEY (\`follower_email\`) REFERENCES \`user\`(\`email\`) ON DELETE CASCADE ON UPDATE NO ACTION
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\` DROP FOREIGN KEY \`FK_e693278faea3d9d67f9f64fbb44\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\` DROP FOREIGN KEY \`FK_53423b3b3071932f4c0e60cd4a5\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\` DROP FOREIGN KEY \`FK_d95a0b4c2cd94d27476fbabbd33\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`route\` DROP FOREIGN KEY \`FK_e4e867e5e97defcb3032b94aa0c\`
        `);
    await queryRunner.query(`
            DROP INDEX \`REL_e4e867e5e97defcb3032b94aa0\` ON \`route\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`route\` DROP INDEX \`IDX_e4e867e5e97defcb3032b94aa0\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`route\` DROP COLUMN \`post_id\`
        `);
    await queryRunner.query(`
            CREATE UNIQUE INDEX \`REL_1479c1e9196859565530ca7aa8\` ON \`post\` (\`route_id\`)
        `);
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\`
            ADD CONSTRAINT \`FK_e693278faea3d9d67f9f64fbb44\` FOREIGN KEY (\`follower_email\`) REFERENCES \`user\`(\`email\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\`
            ADD CONSTRAINT \`FK_53423b3b3071932f4c0e60cd4a5\` FOREIGN KEY (\`place_id\`) REFERENCES \`place\`(\`place_id\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\`
            ADD CONSTRAINT \`FK_d95a0b4c2cd94d27476fbabbd33\` FOREIGN KEY (\`email\`) REFERENCES \`user\`(\`email\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD CONSTRAINT \`FK_1479c1e9196859565530ca7aa82\` FOREIGN KEY (\`route_id\`) REFERENCES \`route\`(\`route_id\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
  }
}
