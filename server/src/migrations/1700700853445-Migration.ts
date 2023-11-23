import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1700700853445 implements MigrationInterface {
    name = 'Migration1700700853445'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            ALTER TABLE \`user\` RENAME \`profile\` \`image_url\` 
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
        ALTER TABLE \`user\` RENAME \`image_url\` \`profile\` 
        `);
    }

}
