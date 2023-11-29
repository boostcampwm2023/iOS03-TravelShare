import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1701243623710 implements MigrationInterface {
    name = 'Migration1701243623710'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            CREATE TABLE \`place\` (
                \`placa_id\` varchar(255) NOT NULL,
                \`place_name\` varchar(255) NOT NULL,
                \`phone_number\` varchar(255) NOT NULL,
                \`category\` varchar(255) NOT NULL,
                \`address\` varchar(255) NOT NULL,
                \`road_address\` varchar(255) NOT NULL,
                \`coordinate\` geometry NOT NULL,
                PRIMARY KEY (\`placa_id\`)
            ) ENGINE = InnoDB
        `);
        await queryRunner.query(`
            CREATE TABLE \`pings\` (
                \`post_id\` int NOT NULL,
                \`place_id\` varchar(255) NOT NULL,
                INDEX \`IDX_42f1a854a62d2e465423c1afeb\` (\`post_id\`),
                INDEX \`IDX_4962bbd26f6bc96b1a7a26c81c\` (\`place_id\`),
                PRIMARY KEY (\`post_id\`, \`place_id\`)
            ) ENGINE = InnoDB
        `);
        await queryRunner.query(`
            ALTER TABLE \`pings\`
            ADD CONSTRAINT \`FK_42f1a854a62d2e465423c1afebb\` FOREIGN KEY (\`post_id\`) REFERENCES \`post\`(\`post_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
        await queryRunner.query(`
            ALTER TABLE \`pings\`
            ADD CONSTRAINT \`FK_4962bbd26f6bc96b1a7a26c81c0\` FOREIGN KEY (\`place_id\`) REFERENCES \`place\`(\`placa_id\`) ON DELETE CASCADE ON UPDATE CASCADE
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`
            ALTER TABLE \`pings\` DROP FOREIGN KEY \`FK_4962bbd26f6bc96b1a7a26c81c0\`
        `);
        await queryRunner.query(`
            ALTER TABLE \`pings\` DROP FOREIGN KEY \`FK_42f1a854a62d2e465423c1afebb\`
        `);
        await queryRunner.query(`
            DROP INDEX \`IDX_4962bbd26f6bc96b1a7a26c81c\` ON \`pings\`
        `);
        await queryRunner.query(`
            DROP INDEX \`IDX_42f1a854a62d2e465423c1afeb\` ON \`pings\`
        `);
        await queryRunner.query(`
            DROP TABLE \`pings\`
        `);
        await queryRunner.query(`
            DROP TABLE \`place\`
        `);
    }

}
