import { MigrationInterface, QueryRunner } from 'typeorm';

export class Migration1700669514013 implements MigrationInterface {
  name = 'Migration1700669514013';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` CHANGE \`mapx\` \`x\` int NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` CHANGE \`mapy\` \`y\` int NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\` DROP FOREIGN KEY \`FK_ac36ed79dc89ca03b3a630baae8\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\` MODIFY COLUMN \`user_email\` varchar(255) NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` CHANGE \`image_url\` \`image_url\` varchar(255) NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD CONSTRAINT \`FK_ac36ed79dc89ca03b3a630baae8\` FOREIGN KEY (\`user_email\`) REFERENCES \`user\`(\`email\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`post\` DROP FOREIGN KEY \`FK_ac36ed79dc89ca03b3a630baae8\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` CHANGE \`image_url\` \`image_url\` varchar(255) NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\` DROP COLUMN \`user_email\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD \`user_email\` varchar(36) NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD CONSTRAINT \`FK_ac36ed79dc89ca03b3a630baae8\` FOREIGN KEY (\`user_email\`) REFERENCES \`user\`(\`user_id\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` DROP COLUMN \`y\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` DROP COLUMN \`x\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\`
            ADD \`mapy\` int NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\`
            ADD \`mapx\` int NOT NULL
        `);
  }
}
