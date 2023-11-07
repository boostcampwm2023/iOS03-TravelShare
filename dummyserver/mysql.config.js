const config = {
    host: 'ec2-43-202-60-200.ap-northeast-2.compute.amazonaws.com',// 카톡방에 최신화된 주소를 여기에 기입합니다.
    port: 3306,
    user: 'macro',
    password: 'macro',
    database: 'macro_project',
    connectionLimit: 10,
    // namedPlaceholders: true,
    charset: 'utf8mb4_unicode_ci',
    // debug: true
    nestTables: true
};
module.exports = {config};