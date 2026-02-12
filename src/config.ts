export interface Config {
  /** ADB device serial (e.g. emulator-5554) */
  serial?: string;
  /** Global timeout per instruction file in ms */
  globalTimeout: number;
  /** Default timeout per action in ms */
  actionTimeout: number;
  /** Default retry count per action */
  retries: number;
  /** CDP connection port */
  cdpPort: number;
  /** Log level */
  logLevel: string;
}

export const defaultConfig: Config = {
  globalTimeout: 300_000, // 5 minutes
  actionTimeout: 30_000,  // 30 seconds
  retries: 1,
  cdpPort: 9222,
  logLevel: 'info',
};
