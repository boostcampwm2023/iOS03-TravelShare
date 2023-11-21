#!/bin/bash

cd /var/app
npm install --production

# migration
npm run migration:run

# prod
npm run start:prod