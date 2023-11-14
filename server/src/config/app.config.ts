import { readFileSync } from 'fs';
import { load } from 'js-yaml';

export default () => {
  return load(readFileSync('application.secrets.yaml', 'utf-8')) as Record<
    string,
    any
  >;
};
