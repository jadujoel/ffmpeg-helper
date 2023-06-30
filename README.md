# ffmpeg-helper

ffmpeg-helper is a simple Node.js module for executing platform-dependent binaries. It supports multiple architectures (x64 and arm64) across macOS, Linux, and Windows.

The module provides the name and path of the binary and a function to run commands with the binary.

The binaries comes from https://github.com/eugeneware/ffmpeg-static/releases

The source code is available at https://github.com/jadujoel/ffmpeg-helper

## Installation

```bash
npm install ffmpeg-helper
```

## Usage

First, import the module in your script.

```javascript
import { name, path, run } from 'ffmpeg-helper';
```

Then, you can use the exported properties and functions:

```javascript
console.log(`Running on platform: ${name}`);
console.log(`Binary path: ${path}`);

run('command to execute with binary')
  .then((output) => {
    console.log(`Command output: ${output}`);
  })
  .catch((error) => {
    console.error(`Error executing command: ${error}`);
  });
```

`run` is a function that executes a command with the platform-dependent binary and returns a Promise. The Promise resolves with the output of the command if it was successful, or rejects with an error if the command failed.

Or if you just want to run the installed ffmpeg directly
```sh
npx ffmpeg-helper --help
```

## Supported Platforms and Architectures

ffmpeg-helper currently supports the following platforms and architectures:

- macOS
  - x64
  - arm64
- Linux
  - x64
  - arm64
- Windows
  - x64
  - ia32

If a platform or architecture is not supported, an error will be thrown.

## Types
if you get "any" as types when importing, then add "@types/node" to your dependencies.
