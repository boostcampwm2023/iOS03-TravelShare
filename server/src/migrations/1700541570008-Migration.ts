import { MigrationInterface, QueryRunner } from 'typeorm';

export class Migration1700541570008 implements MigrationInterface {
  name = 'Migration1700541570008';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            CREATE TABLE \`post\` (
                \`post_id\` int NOT NULL AUTO_INCREMENT,
                \`title\` varchar(255) NOT NULL,
                \`view_num\` int NOT NULL DEFAULT '0',
                \`like_num\` int NOT NULL DEFAULT '0',
                \`summary\` varchar(255) NULL,
                \`start_at\` date NOT NULL,
                \`end_at\` date NOT NULL,
                \`created_at\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
                \`modified_at\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
                \`deleted_at\` datetime(6) NULL,
                \`user_email\` varchar(36) NULL,
                PRIMARY KEY (\`post_id\`)
            ) ENGINE = InnoDB
        `);
    await queryRunner.query(`
            CREATE TABLE \`post_content_element\` (
                \`post_content_element_id\` int NOT NULL AUTO_INCREMENT,
                \`image_url\` varchar(255) NOT NULL,
                \`description\` varchar(255) NOT NULL,
                \`mapx\` int NOT NULL,
                \`mapy\` int NOT NULL,
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
                \`profile\` varchar(255) NULL,
                \`role\` enum ('user', 'admin') NOT NULL DEFAULT 'user',
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
            CREATE TABLE \`post_like_users_user\` (
                \`post_id\` int NOT NULL,
                \`user_email\` varchar(36) NOT NULL,
                INDEX \`IDX_2eac7a67b6894a42f92cc3f7cb\` (\`post_id\`),
                INDEX \`IDX_de292e4c8b2344e1a2cbeaec6a\` (\`user_email\`),
                PRIMARY KEY (\`post_id\`, \`user_email\`)
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
            CREATE TABLE \`post_ssss\` (
                \`userUserId\` varchar(36) NOT NULL,
                \`postPostId\` int NOT NULL,
                INDEX \`IDX_f43a5aa94caa7490facc1d7512\` (\`userUserId\`),
                INDEX \`IDX_918a0e6ab4a9e118699776076a\` (\`postPostId\`),
                PRIMARY KEY (\`userUserId\`, \`postPostId\`)
            ) ENGINE = InnoDB
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD CONSTRAINT \`FK_ac36ed79dc89ca03b3a630baae8\` FOREIGN KEY (\`user_email\`) REFERENCES \`user\`(\`user_id\`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
            ALTER TABLE \`post_like_users_user\`
            ADD CONSTRAINT \`FK_2eac7a67b6894a42f92cc3f7cb7\` FOREIGN KEY (\`post_id\`) REFERENCES \`post\`(\`post_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_like_users_user\`
            ADD CONSTRAINT \`FK_de292e4c8b2344e1a2cbeaec6ac\` FOREIGN KEY (\`user_email\`) REFERENCES \`user\`(\`user_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\`
            ADD CONSTRAINT \`FK_dca93378123a3be0d10f49d03ed\` FOREIGN KEY (\`follower_id\`) REFERENCES \`user\`(\`user_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\`
            ADD CONSTRAINT \`FK_7642e3756290af9092754cda85f\` FOREIGN KEY (\`followee_id\`) REFERENCES \`user\`(\`user_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_ssss\`
            ADD CONSTRAINT \`FK_f43a5aa94caa7490facc1d75124\` FOREIGN KEY (\`userUserId\`) REFERENCES \`user\`(\`user_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_ssss\`
            ADD CONSTRAINT \`FK_918a0e6ab4a9e118699776076a7\` FOREIGN KEY (\`postPostId\`) REFERENCES \`post\`(\`post_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`post_ssss\` DROP FOREIGN KEY \`FK_918a0e6ab4a9e118699776076a7\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_ssss\` DROP FOREIGN KEY \`FK_f43a5aa94caa7490facc1d75124\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\` DROP FOREIGN KEY \`FK_7642e3756290af9092754cda85f\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`user_followers_relation\` DROP FOREIGN KEY \`FK_dca93378123a3be0d10f49d03ed\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_like_users_user\` DROP FOREIGN KEY \`FK_de292e4c8b2344e1a2cbeaec6ac\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_like_users_user\` DROP FOREIGN KEY \`FK_2eac7a67b6894a42f92cc3f7cb7\`
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
            DROP INDEX \`IDX_918a0e6ab4a9e118699776076a\` ON \`post_ssss\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_f43a5aa94caa7490facc1d7512\` ON \`post_ssss\`
        `);
    await queryRunner.query(`
            DROP TABLE \`post_ssss\`
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
            DROP INDEX \`IDX_de292e4c8b2344e1a2cbeaec6a\` ON \`post_like_users_user\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_2eac7a67b6894a42f92cc3f7cb\` ON \`post_like_users_user\`
        `);
    await queryRunner.query(`
            DROP TABLE \`post_like_users_user\`
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
