import { MigrationInterface, QueryRunner } from 'typeorm';

export class Migration1701763230245 implements MigrationInterface {
  name = 'Migration1701763230245';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`place\` CHANGE \`phone_number\` \`phone_number\` varchar(255) NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`place\` CHANGE \`road_address\` \`road_address\` varchar(255) NULL
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
            ALTER TABLE \`place\` CHANGE \`road_address\` \`road_address\` varchar(255) NOT NULL
        `);
    await queryRunner.query(`
            ALTER TABLE \`place\` CHANGE \`phone_number\` \`phone_number\` varchar(255) NOT NULL
        `);
  }
}
