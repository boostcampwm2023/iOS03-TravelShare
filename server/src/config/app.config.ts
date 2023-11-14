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
  config.jwt.secret = createSecretKey(config.jwt.secret).export();
  return config;
};
