'use strict';

const fs = require('fs'),
    env = process.env;

const relativePath = env.npm_package_name;
const pathFile = `${env.INIT_CWD}/package.json`;

const content = require(pathFile);
content.scripts.deploy = `sh node_modules/${relativePath}/deploy.sh $env`;
fs.writeFileSync(pathFile, JSON.stringify(content));