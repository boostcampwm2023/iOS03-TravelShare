import { readFileSync } from 'fs';
import { load } from 'js-yaml';
import { createSecretKey } from 'crypto';

export default () => {
  const config: Record<string, any> = load(readFileSync('application.yaml', 'utf-8'));
  config.application.jwt.secret = createSecretKey(
    config.application.jwt.secret,
  ).export();
  config.apple.client_secret.secret = readFileSync(
    config.apple.client_secret.secret,
  );
  return config;
};
