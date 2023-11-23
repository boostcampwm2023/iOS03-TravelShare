import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1700706919624 implements MigrationInterface {
    name = 'Migration1700706919624'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            ALTER TABLE \`post\` DROP FOREIGN KEY \`FK_ac36ed79dc89ca03b3a630baae8\`
        `);
        await queryRunner.query(`
            ALTER TABLE \`post\` CHANGE \`user_email\` \`user_id\` varchar(36) NULL
        `);
        await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD CONSTRAINT \`FK_52378a74ae3724bcab44036645b\` FOREIGN KEY (\`user_id\`) REFERENCES \`user\`(\`user_id\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            ALTER TABLE \`post\` DROP FOREIGN KEY \`FK_52378a74ae3724bcab44036645b\`
        `);
        await queryRunner.query(`
            ALTER TABLE \`post\` CHANGE \`user_id\` \`user_email\` varchar(36) NULL
        `);
        await queryRunner.query(`
            ALTER TABLE \`post\`
            ADD CONSTRAINT \`FK_ac36ed79dc89ca03b3a630baae8\` FOREIGN KEY (\`user_email\`) REFERENCES \`user\`(\`user_id\`) ON DELETE NO ACTION ON UPDATE NO ACTION
        `);
    }

}
