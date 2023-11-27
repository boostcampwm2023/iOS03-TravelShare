import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1701114968126 implements MigrationInterface {
    name = 'Migration1701114968126'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            ALTER TABLE \`user\`
            ADD \`introduce\` varchar(255) NULL
        `);
        await queryRunner.query(`
            CREATE FULLTEXT INDEX \`IDX_90c38ad246e5e67e3f8da3eebb\` ON \`post_content_element\` (\`description\`) WITH PARSER ngram
        `);
        await queryRunner.query(`
            CREATE FULLTEXT INDEX \`IDX_e28aa0c4114146bfb1567bfa9a\` ON \`post\` (\`title\`) WITH PARSER ngram
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            DROP INDEX \`IDX_e28aa0c4114146bfb1567bfa9a\` ON \`post\`
        `);
        await queryRunner.query(`
            DROP INDEX \`IDX_90c38ad246e5e67e3f8da3eebb\` ON \`post_content_element\`
        `);
        await queryRunner.query(`
            ALTER TABLE \`user\` DROP COLUMN \`introduce\`
        `);
    }

}
