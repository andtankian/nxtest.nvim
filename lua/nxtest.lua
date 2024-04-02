local utils = require("utils")

local cmd = vim.cmd
local user_cmd = vim.api.nvim_create_user_command

local function run_cmd(command_table)
  local command = table.concat(command_table, "")
  cmd("vsplit | terminal cd " .. vim.loop.cwd() .. "&& pnpm nx run " .. command)
end

local function run_test_for_project()
  local project_name = utils.get_nx_project_name()
  local command = project_name .. ":test" .. " --watch"
  run_cmd(command)
end

local function run_test_for_file(opts)
  local command_table = {}

  local project_name = utils.get_nx_project_name()

  table.insert(command_table, project_name)
  table.insert(command_table, ":test")
  table.insert(command_table, " --skip-nx-cache")
  table.insert(command_table, " --runTestsByPath ")
  table.insert(command_table, utils.get_file_path())
  table.insert(command_table, " --watch")
  if opts ~= nil then
    table.insert(command_table, " " .. opts.args)
  end

  run_cmd(command_table)
end

local function run_test_for_single()
  local command_table = {}

  local project_name = utils.get_nx_project_name()

  local line = vim.api.nvim_get_current_line()
  local _, _, test_name = string.find(line, "^%s*%a+%(['\"](.+)['\"]")

  if test_name ~= nil then
    table.insert(command_table, project_name)
    table.insert(command_table, ":test")
    table.insert(command_table, " --skip-nx-cache")
    table.insert(command_table, " --runTestsByPath ")
    table.insert(command_table, utils.get_file_path())
    table.insert(command_table, " --testNamePattern='\"")
    table.insert(command_table, test_name)
    table.insert(command_table, "$\"'")
    table.insert(command_table, " --watch")
    if opts ~= nil then
      table.insert(command_table, " " .. opts.args)
    end

    run_cmd(command_table)
  end
end

local M = {}

M.setup = function()
  user_cmd("NxTest", run_test_for_project, { nargs = 0 })
  user_cmd("NxTestFile", run_test_for_file, { nargs = "*" })
  user_cmd("NxTestSingle", run_test_for_single, { nargs = 0 })
end

return M
