export interface InstructionFile {
  name: string;
  description?: string;
  device?: { avd?: string; serial?: string };
  timeout?: number;
  actions: Action[];
}

export type Action =
  | NavigateAction
  | ScrollAction
  | ClickAction
  | TypeAction
  | WaitAction
  | WaitForAction
  | ScreenshotAction
  | AssertAction;

export interface NavigateAction {
  type: 'navigate';
  url: string;
}

export interface ScrollAction {
  type: 'scroll';
  direction: 'up' | 'down' | 'left' | 'right';
  amount?: number;
}

export interface ClickAction {
  type: 'click';
  selector?: string;
  x?: number;
  y?: number;
}

export interface TypeAction {
  type: 'type';
  text: string;
  selector?: string;
}

export interface WaitAction {
  type: 'wait';
  ms: number;
}

export interface WaitForAction {
  type: 'wait_for';
  selector: string;
  timeout?: number;
}

export interface ScreenshotAction {
  type: 'screenshot';
  path?: string;
}

export interface AssertAction {
  type: 'assert';
  selector: string;
  contains?: string;
  visible?: boolean;
}

export interface ActionResult {
  action: Action;
  success: boolean;
  duration: number;
  error?: string;
}

export interface ExecutionResult {
  instruction: string;
  totalActions: number;
  passed: number;
  failed: number;
  results: ActionResult[];
  duration: number;
}
