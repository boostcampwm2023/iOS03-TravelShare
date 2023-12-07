import { MigrationInterface, QueryRunner } from 'typeorm';

export class Migration1701877593464 implements MigrationInterface {
  name = 'Migration1701877593464';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            DROP INDEX \`IDX_fdd04e5822a194b88c05be6960\` ON \`post\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\` DROP COLUMN \`score\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD \`score\` double NOT NULL DEFAULT '0'
        `);
    await queryRunner.query(`
            CREATE INDEX \`IDX_fdd04e5822a194b88c05be6960\` ON \`post\` (\`score\`)
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            DROP INDEX \`IDX_fdd04e5822a194b88c05be6960\` ON \`post\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\` DROP COLUMN \`score\`
        `);
    await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD \`score\` int NOT NULL DEFAULT '0'
        `);
    await queryRunner.query(`
            CREATE INDEX \`IDX_fdd04e5822a194b88c05be6960\` ON \`post\` (\`score\`)
        `);
  }
}