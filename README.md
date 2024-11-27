# NxTest.nvim

A Neovim plugin for running and debugging tests (jest only) in Nx monorepos.

The difference of using it instead other test plugins for neovim is that you can take advantage of the NX cache and graph dependencies.

## Features

- Run tests for all projects
- Run tests for a specific project
- Run tests for the current file
- Run or debug a single test
- Run tests for affected projects
- Watch mode support
- Integrated debugging with Node.js inspector
- Configurable terminal position

## Prerequisites

- Neovim >= 0.5.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- An Nx monorepo using `pnpm`
- Node.js

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "andtankian/nxtest.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    terminal_position = "buffer" -- default
  },
}
```

## Configuration

The plugin can be configured with the following options:

```lua
require('nxtest').setup({
  -- Where to open the terminal window
  -- Possible values: "vertical", "horizontal", "buffer"
  terminal_position = "buffer" -- default
})
```

### Terminal Position Options

- `buffer`: Opens in a new buffer (default)
- `vertical`: Opens in a vertical split
- `horizontal`: Opens in a horizontal split

## Commands

- `:NxTestAll` - Run tests for all projects in the monorepo
- `:NxTest` - Run tests for the current project (determined by project.json)
- `:NxTestFile` - Run tests for the current file in watch mode
- `:NxTestSingle` - Run the test under cursor in watch mode
- `:NxTestDebugSingle` - Debug the test under cursor with Node.js inspector
- `:NxTestAffected` - Run tests for projects affected by recent changes

All commands support additional arguments that will be passed directly to the nx command.

## Usage

1. Navigate to a test file in your Nx monorepo
2. Use any of the commands above to run or debug tests

### Running a Single Test

1. Place your cursor on a test case (it or test block)
2. Run `:NxTestSingle` to run just that test
3. The test will run in watch mode
4. The plugin will automatically detect the test context (describe block) if present

### Debugging a Test

1. Place your cursor on a test case
2. Run `:NxTestDebugSingle`
3. The test will start in debug mode with the `--inspect-wait` flag
4. Connect your debugger (e.g., Chrome DevTools) to continue execution
5. The Node.js inspector will be available at the default port

### Running Tests for Affected Projects

1. Run `:NxTestAffected`
2. The plugin will use Nx's affected command to determine which projects have been impacted by recent changes
3. Tests will run only for the affected projects

## Project Structure Requirements

The plugin expects:
- A valid Nx monorepo structure
- `project.json` files in project roots with a valid `name` field
- pnpm as the package manager
- Jest as the test runner

## Plugin Structure

```
lua/
  nxtest/
    init.lua           -- Main entry point
    commands.lua       -- Command definitions
    config.lua         -- Configuration handling
    terminal.lua       -- Terminal management
    test_runner.lua    -- Test execution logic
    utils/
      init.lua         -- Utility functions
      project.lua      -- Project-related utilities
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT
