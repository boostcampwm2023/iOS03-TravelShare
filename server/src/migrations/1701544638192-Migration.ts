import { MigrationInterface, QueryRunner } from 'typeorm';

export class Migration1701544638192 implements MigrationInterface {
  name = 'Migration1701544638192';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`pins\` DROP FOREIGN KEY \`FK_53423b3b3071932f4c0e60cd4a5\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`place\` CHANGE \`placa_id\` \`place_id\` varchar(255) NOT NULL
        `);
    await queryRunner.query(`
            CREATE FULLTEXT INDEX \`IDX_065d4d8f3b5adb4a08841eae3c\` ON \`user\` (\`name\`) WITH PARSER ngram
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\`
            ADD CONSTRAINT \`FK_53423b3b3071932f4c0e60cd4a5\` FOREIGN KEY (\`place_id\`) REFERENCES \`place\`(\`place_id\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`pins\` DROP FOREIGN KEY \`FK_53423b3b3071932f4c0e60cd4a5\`
        `);
    await queryRunner.query(`
            DROP INDEX \`IDX_065d4d8f3b5adb4a08841eae3c\` ON \`user\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`place\` DROP COLUMN \`place_id\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`place\`
            ADD \`place_id\` varchar(255) NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`place\`
            ADD PRIMARY KEY (\`place_id\`)
        `);
    await queryRunner.query(`
            ALTER TABLE \`place\` CHANGE \`place_id\` \`placa_id\` varchar(255) NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`pins\`
            ADD CONSTRAINT \`FK_53423b3b3071932f4c0e60cd4a5\` FOREIGN KEY (\`place_id\`) REFERENCES \`place\`(\`placa_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
  }
}
