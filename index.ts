import { exec } from 'child_process';
import { arch, platform } from 'os';
import { resolve } from 'path';
import { promisify } from 'util';

export type OperatingSystem = 'darwin' | 'linux' | 'win32';
export type Architecture = 'x64' | 'arm64';

export const binaries = {
  darwin: {
    x64: 'ffmpeg-darwin-x64.app/Contents/MacOS/ffmpeg-darwin-x64',
    arm64: 'ffmpeg-darwin-arm64.app/Contents/MacOS/ffmpeg-darwin-arm64',
  },
  linux: {
    x64: 'linux-x64',
    arm64: 'linux-arm64',
  },
  win32: {
    x64: 'win32-x64.exe',
    arm64: 'win32-ia32.exe',
  },
} as const;

export const isSupportedPlatform = (operatingSystem: string): operatingSystem is OperatingSystem =>
  Object.keys(binaries).includes(operatingSystem);

export const isSupportedArchitecture = (architecture: string): architecture is Architecture =>
  Object.keys(binaries[platform()]).includes(architecture);

export const platf = platform();
export const architecture = arch();
if (!isSupportedPlatform(platf)) {
  throw new Error(`Unsupported platform: ${platform()}`);
} else if (!isSupportedArchitecture(architecture)) {
  throw new Error(`Unsupported architecture: ${architecture}`);
}

export const name = binaries[platf][architecture];

// when running this with for example @jadujoel/runts
// then the path incorrectly could show up as the current directory + name
// which is why we use the if check
export const path = resolve().includes('node_modules')
  ? resolve(resolve(), name)
  : resolve(resolve(), 'node_modules', 'ffmpeg-helper', name);

export const run = (cmd: string) => {
  return promisify(exec)(`${path} ${cmd}`);
}
