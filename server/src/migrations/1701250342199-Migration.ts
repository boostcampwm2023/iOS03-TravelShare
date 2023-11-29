import { MigrationInterface, QueryRunner } from 'typeorm';

export class Migration1701250342199 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`pings\` RENAME \`pins\`
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`pins\` RENAME \`pings\`
        `);
  }
}
