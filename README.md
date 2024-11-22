This plugin executes tests in a Neovim terminal buffer using NX `test` target.


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

## Prerequisites

- Neovim >= 0.5.0
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- An Nx monorepo using pnpm
- Node.js

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "andrewribeiro/nxtest.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("nxtest").setup()
    end,
}
```

## Commands

- `:NxTestAll` - Run tests for all projects
- `:NxTest` - Run tests for the current project
- `:NxTestFile` - Run tests for the current file
- `:NxTestSingle` - Run the test under cursor
- `:NxTestDebugSingle` - Debug the test under cursor
- `:NxTestAffected` - Run tests for affected projects

## Usage

1. Navigate to a test file in your Nx monorepo
2. Use any of the commands above to run or debug tests

### Running a Single Test

1. Place your cursor on a test case
2. Run `:NxTestSingle` to run just that test
3. The test will run in watch mode

### Debugging a Test

1. Place your cursor on a test case
2. Run `:NxTestDebugSingle`
3. The test will start in debug mode with the `--inspect-wait` flag
4. Connect your debugger (e.g., Chrome DevTools) to continue execution

## Project Structure Requirements

The plugin expects:
- A valid Nx monorepo structure
- `project.json` files in project roots
- pnpm as the package manager

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT
