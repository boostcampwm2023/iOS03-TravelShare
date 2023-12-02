import { readFileSync } from 'fs';
import { load } from 'js-yaml';
import { DataSource, DataSourceOptions } from 'typeorm';

const options: DataSourceOptions = load(
  readFileSync(
    process.env.NODE_ENV === 'production'
      ? 'application.yaml'
      : 'production.yaml',
    'utf-8',
  ),
)?.['typeorm'];

export default new DataSource(options);
