import { readFileSync } from 'fs';
import { load } from 'js-yaml';
import { createSecretKey } from 'crypto';

export default (path?: string) => {
  const config: Record<string, any> = load(
    readFileSync(path ?? 'application.yaml', 'utf-8'),
  );
  config.application.jwt.secret = createSecretKey(
    config.application.jwt.secret,
  ).export();
  return config;
};
