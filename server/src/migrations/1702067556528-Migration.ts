import { MigrationInterface, QueryRunner } from 'typeorm';

export class Migration1702067556528 implements MigrationInterface {
  name = 'Migration1702067556528';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`post\` DROP FOREIGN KEY \`FK_ac36ed79dc89ca03b3a630baae8\`
        `);
    await queryRunner.query(`
            CREATE TABLE \`report\` (
                \`reportId\` int NOT NULL AUTO_INCREMENT,
                \`title\` varchar(255) NULL,
                \`description\` varchar(255) NULL,
                \`createdAt\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
                \`modifiedAt\` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
                \`deletedAt\` datetime(6) NULL,
                \`post_id\` int NULL,
                \`user_email\` varchar(255) NULL,
                PRIMARY KEY (\`reportId\`)
            ) ENGINE = InnoDB
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD CONSTRAINT \`FK_ac36ed79dc89ca03b3a630baae8\` FOREIGN KEY (\`user_email\`) REFERENCES \`user\`(\`email\`) ON DELETE CASCADE ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`report\`
            ADD CONSTRAINT \`FK_265b3dc7c7f692f016115d46a29\` FOREIGN KEY (\`post_id\`) REFERENCES \`post\`(\`post_id\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
    await queryRunner.query(`
            ALTER TABLE \`report\`
            ADD CONSTRAINT \`FK_63283843a892a31dcbe167ddfc8\` FOREIGN KEY (\`user_email\`) REFERENCES \`user\`(\`email\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`report\` DROP FOREIGN KEY \`FK_63283843a892a31dcbe167ddfc8\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`report\` DROP FOREIGN KEY \`FK_265b3dc7c7f692f016115d46a29\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\` DROP FOREIGN KEY \`FK_ac36ed79dc89ca03b3a630baae8\`
        `);
    await queryRunner.query(`
            DROP TABLE \`report\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD CONSTRAINT \`FK_ac36ed79dc89ca03b3a630baae8\` FOREIGN KEY (\`user_email\`) REFERENCES \`user\`(\`email\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
  }
}
