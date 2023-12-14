#!/bin/bash

cd /var/app

# migration
npm run migration:run -- --transaction all

# prod
npm run start:prod