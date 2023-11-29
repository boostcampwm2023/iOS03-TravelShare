import { MigrationInterface, QueryRunner } from 'typeorm';

export class Migration1701280194449 implements MigrationInterface {
  name = 'Migration1701280194449';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`pins\` DROP FOREIGN KEY \`FK_42f1a854a62d2e465423c1afebb\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\` DROP FOREIGN KEY \`FK_4962bbd26f6bc96b1a7a26c81c0\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_42f1a854a62d2e465423c1afeb\` ON \`pins\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_4962bbd26f6bc96b1a7a26c81c\` ON \`pins\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` CHANGE \`image_url\` \`image_url\` varchar(255) NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` CHANGE \`description\` \`description\` varchar(255) NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` CHANGE \`coordinate\` \`coordinate\` geometry NULL
        `);
    await queryRunner.query(`
            CREATE INDEX \`IDX_906343bdb602f10433840f208c\` ON \`pins\` (\`post_id\`)
        `);
    await queryRunner.query(`
            CREATE INDEX \`IDX_53423b3b3071932f4c0e60cd4a\` ON \`pins\` (\`place_id\`)
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\`
            ADD CONSTRAINT \`FK_906343bdb602f10433840f208c5\` FOREIGN KEY (\`post_id\`) REFERENCES \`post\`(\`post_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\`
            ADD CONSTRAINT \`FK_53423b3b3071932f4c0e60cd4a5\` FOREIGN KEY (\`place_id\`) REFERENCES \`place\`(\`placa_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`pins\` DROP FOREIGN KEY \`FK_53423b3b3071932f4c0e60cd4a5\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\` DROP FOREIGN KEY \`FK_906343bdb602f10433840f208c5\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_53423b3b3071932f4c0e60cd4a\` ON \`pins\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_906343bdb602f10433840f208c\` ON \`pins\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` CHANGE \`coordinate\` \`coordinate\` geometry NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` CHANGE \`description\` \`description\` varchar(255) NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`post_content_element\` CHANGE \`image_url\` \`image_url\` varchar(255) NULL
        `);
    await queryRunner.query(`
            CREATE INDEX \`IDX_4962bbd26f6bc96b1a7a26c81c\` ON \`pins\` (\`place_id\`)
        `);
    await queryRunner.query(`
            CREATE INDEX \`IDX_42f1a854a62d2e465423c1afeb\` ON \`pins\` (\`post_id\`)
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\`
            ADD CONSTRAINT \`FK_4962bbd26f6bc96b1a7a26c81c0\` FOREIGN KEY (\`place_id\`) REFERENCES \`place\`(\`placa_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\`
            ADD CONSTRAINT \`FK_42f1a854a62d2e465423c1afebb\` FOREIGN KEY (\`post_id\`) REFERENCES \`post\`(\`post_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
  }
}
