import { readFileSync } from 'fs';
import { load } from 'js-yaml';
import { DataSource, DataSourceOptions } from 'typeorm';

const options: DataSourceOptions = load(
  readFileSync('application.yaml', 'utf-8'),
)?.['typeorm'];

export default new DataSource(options);