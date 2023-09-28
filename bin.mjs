#!/usr/bin/env node
import { run } from './index.js';
const argv = process.argv.slice(2);
run(argv.join(" ")).then((result) => {
    console.error(result.stderr);
    console.log(result.stdout);
    process.exit(result.code);
});
