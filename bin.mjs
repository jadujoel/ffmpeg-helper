#!/usr/bin/env node
import { run } from './index.js';
run(process.argv.slice(2)).then((result) => {
    console.error(result.stderr);
    console.log(result.stdout);
    process.exit(result.code);
});
