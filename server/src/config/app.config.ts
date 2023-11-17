import { readFileSync } from 'fs';
import { load } from 'js-yaml';
import { createSecretKey } from 'crypto';

export default () => {
  let config: Record<string, any>;
  switch (process.env.NODE_ENV) {
    case 'development':
      config = load(readFileSync('application.development.yaml', 'utf-8'));
      break;
    case 'production':
      config = load(readFileSync('application.production.yaml', 'utf-8'));
      break;
  }
  config.application.jwt.secret = createSecretKey(
    config.application.jwt.secret,
  ).export();
  config.apple.client_secret.secret = readFileSync(
    config.apple.client_secret.secret,
  );
  return config;
};
