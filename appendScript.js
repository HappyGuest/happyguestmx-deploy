'use strict';

const fs = require('fs'),
    env = process.env;

const relativePath = env.npm_package_name,
    pathFile = `${env.INIT_CWD}/package.json`;

let packageFile;

function appendScript() {
    try {
        packageFile = require(pathFile);
        writePackage(packageFile)
    }
    catch (err) {
        if (err.code === 'MODULE_NOT_FOUND') {
            packageFile = require('./src/package.json');
            writePackage(packageFile);
        } else console.log(err);
    }
}

function writePackage(packageFile) {
    try {
        const scriptCommand = `sh node_modules/${relativePath}/deploy.sh $env`;
        if (packageFile.scripts) {
            packageFile.scripts.deploy = scriptCommand;
        }
        else {
            packageFile.scripts = { deploy: scriptCommand };
        }
        fs.writeFileSync(pathFile, JSON.stringify(packageFile, null, 4));
    }
    catch (err) {
        console.log(err);
    }
}

appendScript();