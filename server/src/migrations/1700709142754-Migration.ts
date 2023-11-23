import { MigrationInterface, QueryRunner } from 'typeorm';

export class Migration1700709142754 implements MigrationInterface {
  name = 'Migration1700709142754';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            CREATE TABLE \`post\` (
                \`post_id\` int NOT NULL AUTO_INCREMENT,
                \`title\` varchar(255) NOT NULL,
                \`view_num\` int NOT NULL DEFAULT '0',
                \`like_num\` int NOT NULL DEFAULT '0',
                \`summary\` varchar(255) NULL,
                \`route\` json NOT NULL,
                \`hashtag\` json NULL,
                \`start_at\` date NOT NULL,
                \`end_at\` date NOT NULL,
                \`created_at\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
                \`modified_at\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
                \`deleted_at\` datetime(6) NULL,
                \`user_email\` varchar(255) NULL,
                PRIMARY KEY (\`post_id\`)
            ) ENGINE = InnoDB
        `);
    await queryRunner.query(`
            CREATE TABLE \`post_content_element\` (
                \`post_content_element_id\` int NOT NULL AUTO_INCREMENT,
                \`image_url\` varchar(255) NULL,
                \`description\` varchar(255) NOT NULL,
                \`x\` int NOT NULL,
                \`y\` int NOT NULL,
                \`post_id\` int NULL,
                PRIMARY KEY (\`post_content_element_id\`)
            ) ENGINE = InnoDB
        `);
    await queryRunner.query(`
            CREATE TABLE \`user\` (
                \`user_id\` varchar(36) NOT NULL,
                \`email\` varchar(255) NOT NULL,
                \`name\` varchar(255) NOT NULL,
                \`password\` varchar(255) NOT NULL,
                \`image_url\` varchar(255) NULL,
                \`role\` enum ('user', 'admin') NOT NULL DEFAULT 'user',
                \`created_at\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
                \`modified_at\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
                \`deleted_at\` datetime(6) NULL,
                UNIQUE INDEX \`IDX_e12875dfb3b1d92d7d7c5377e2\` (\`email\`),
                PRIMARY KEY (\`user_id\`)
            ) ENGINE = InnoDB
        `);
    await queryRunner.query(`
            CREATE TABLE \`apple_auth\` (
                \`apple_id\` varchar(255) NOT NULL,
                \`user_id\` varchar(36) NULL,
                UNIQUE INDEX \`REL_42f2ee24ee4e6afb73ba904fb6\` (\`user_id\`),
                PRIMARY KEY (\`apple_id\`)
            ) ENGINE = InnoDB
        `);
    await queryRunner.query(`
            CREATE TABLE \`post_likes_users\` (
                \`post_id\` int NOT NULL,
                \`email\` varchar(255) NOT NULL,
                INDEX \`IDX_ffda72142eef274a2f2755a720\` (\`post_id\`),
                INDEX \`IDX_d95a0b4c2cd94d27476fbabbd3\` (\`email\`),
                PRIMARY KEY (\`post_id\`, \`email\`)
            ) ENGINE = InnoDB
        `);
    await queryRunner.query(`
            CREATE TABLE \`user_followers_relation\` (
                \`follower_id\` varchar(36) NOT NULL,
                \`followee_id\` varchar(36) NOT NULL,
                INDEX \`IDX_dca93378123a3be0d10f49d03e\` (\`follower_id\`),
                INDEX \`IDX_7642e3756290af9092754cda85\` (\`followee_id\`),
                PRIMARY KEY (\`follower_id\`, \`followee_id\`)
            ) ENGINE = InnoDB
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\` DROP PRIMARY KEY
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\`
            ADD PRIMARY KEY (\`post_id\`)
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_d95a0b4c2cd94d27476fbabbd3\` ON \`post_likes_users\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\` DROP COLUMN \`email\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\`
            ADD \`email\` varchar(36) NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\` DROP PRIMARY KEY
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\`
            ADD PRIMARY KEY (\`post_id\`, \`email\`)
        `);
    await queryRunner.query(`
            CREATE INDEX \`IDX_d95a0b4c2cd94d27476fbabbd3\` ON \`post_likes_users\` (\`email\`)
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD CONSTRAINT \`FK_ac36ed79dc89ca03b3a630baae8\` FOREIGN KEY (\`user_email\`) REFERENCES \`user\`(\`email\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\`
            ADD CONSTRAINT \`FK_588a7bf10475a4b9d6981ea1caa\` FOREIGN KEY (\`post_id\`) REFERENCES \`post\`(\`post_id\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`apple_auth\`
            ADD CONSTRAINT \`FK_42f2ee24ee4e6afb73ba904fb6e\` FOREIGN KEY (\`user_id\`) REFERENCES \`user\`(\`user_id\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\`
            ADD CONSTRAINT \`FK_ffda72142eef274a2f2755a7204\` FOREIGN KEY (\`post_id\`) REFERENCES \`post\`(\`post_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\`
            ADD CONSTRAINT \`FK_d95a0b4c2cd94d27476fbabbd33\` FOREIGN KEY (\`email\`) REFERENCES \`user\`(\`email\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\`
            ADD CONSTRAINT \`FK_dca93378123a3be0d10f49d03ed\` FOREIGN KEY (\`follower_id\`) REFERENCES \`user\`(\`user_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\`
            ADD CONSTRAINT \`FK_7642e3756290af9092754cda85f\` FOREIGN KEY (\`followee_id\`) REFERENCES \`user\`(\`user_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\` DROP FOREIGN KEY \`FK_7642e3756290af9092754cda85f\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\` DROP FOREIGN KEY \`FK_dca93378123a3be0d10f49d03ed\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\` DROP FOREIGN KEY \`FK_d95a0b4c2cd94d27476fbabbd33\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\` DROP FOREIGN KEY \`FK_ffda72142eef274a2f2755a7204\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`apple_auth\` DROP FOREIGN KEY \`FK_42f2ee24ee4e6afb73ba904fb6e\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` DROP FOREIGN KEY \`FK_588a7bf10475a4b9d6981ea1caa\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\` DROP FOREIGN KEY \`FK_ac36ed79dc89ca03b3a630baae8\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_d95a0b4c2cd94d27476fbabbd3\` ON \`post_likes_users\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\` DROP PRIMARY KEY
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\`
            ADD PRIMARY KEY (\`post_id\`)
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\` DROP COLUMN \`email\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\`
            ADD \`email\` varchar(255) NOT NULL
        `);
    await queryRunner.query(`
            CREATE INDEX \`IDX_d95a0b4c2cd94d27476fbabbd3\` ON \`post_likes_users\` (\`email\`)
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\` DROP PRIMARY KEY
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_likes_users\`
            ADD PRIMARY KEY (\`post_id\`, \`email\`)
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_7642e3756290af9092754cda85\` ON \`user_followers_relation\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_dca93378123a3be0d10f49d03e\` ON \`user_followers_relation\`
        `);
    await queryRunner.query(`
            DROP TABLE \`user_followers_relation\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_d95a0b4c2cd94d27476fbabbd3\` ON \`post_likes_users\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_ffda72142eef274a2f2755a720\` ON \`post_likes_users\`
        `);
    await queryRunner.query(`
            DROP TABLE \`post_likes_users\`
        `);
    await queryRunner.query(`
            DROP INDEX \`REL_42f2ee24ee4e6afb73ba904fb6\` ON \`apple_auth\`
        `);
    await queryRunner.query(`
            DROP TABLE \`apple_auth\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_e12875dfb3b1d92d7d7c5377e2\` ON \`user\`
        `);
    await queryRunner.query(`
            DROP TABLE \`user\`
        `);
    await queryRunner.query(`
            DROP TABLE \`post_content_element\`
        `);
    await queryRunner.query(`
            DROP TABLE \`post\`
        `);
  }
}
