
export class BreakPointType<T> {
  options: Record<string, T>

  constructor(option: Record<string, T>) {
    this.options = option
  }

  getValue<T>(currentBreakPoint: string):T {
    return this.options[currentBreakPoint]
  }
}