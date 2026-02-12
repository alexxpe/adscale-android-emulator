import { Command } from 'commander';
import pino from 'pino';

const logger = pino({ name: 'adb-auto' });

const program = new Command();

program
  .name('adb-auto')
  .description('Android Emulator Browser Automation Service')
  .version('0.1.0');

program
  .command('run')
  .description('Run an instruction file against an emulator')
  .argument('<file>', 'Path to instruction JSON file')
  .option('-s, --serial <serial>', 'Device serial (e.g. emulator-5554)')
  .option('-d, --dry-run', 'Validate and log actions without executing')
  .option('-t, --timeout <ms>', 'Global timeout in ms', '300000')
  .action((file, options) => {
    logger.info({ file, options }, 'Running instruction file');
    // TODO: Implement instruction runner
  });

program
  .command('validate')
  .description('Validate an instruction file without running it')
  .argument('<file>', 'Path to instruction JSON file')
  .action((file) => {
    logger.info({ file }, 'Validating instruction file');
    // TODO: Implement validation
  });

program
  .command('devices')
  .description('List connected ADB devices')
  .action(() => {
    logger.info('Listing devices');
    // TODO: Implement device listing
  });

program
  .command('avds')
  .description('List available Android Virtual Devices')
  .action(() => {
    logger.info('Listing AVDs');
    // TODO: Implement AVD listing
  });

program.parse();
