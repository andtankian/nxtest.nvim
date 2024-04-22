local helpers = require("helpers")

local cmd = vim.cmd
local user_cmd = vim.api.nvim_create_user_command

local function run_cmd(command_table, opts)
	if opts ~= nil then
		table.insert(command_table, " " .. opts.args)
	end

	local command = table.concat(command_table, "")
	cmd("vsplit | terminal cd " .. vim.loop.cwd() .. " && pnpm nx " .. command)
end

local function run_test_for_all_projects(opts)
	local command_table = {}

	table.insert(command_table, " run-many -t test")

	run_cmd(command_table, opts)
end

local function run_test_for_project(opts)
	local command_table = {}

	local project_name = helpers.get_nx_project_name()

	table.insert(command_table, " run ")
	table.insert(command_table, project_name)
	table.insert(command_table, ":test")

	run_cmd(command_table, opts)
end

local function run_test_for_file(opts)
	local command_table = {}

  print(helpers)

	local project_name = helpers.get_nx_project_name()

  print(project_name)


	table.insert(command_table, " run ")
	table.insert(command_table, project_name)
	table.insert(command_table, ":test")
	table.insert(command_table, ' --testPathPattern="')
	table.insert(command_table, helpers.get_file_path())
	table.insert(command_table, '" --watch')

	run_cmd(command_table, opts)
end

local function run_test_for_single(opts)
	local command_table = {}

	local project_name = helpers.get_nx_project_name()

	local line = vim.api.nvim_get_current_line()
	local _, _, test_name = string.find(line, "^%s*%a+%(['\"](.+)['\"]")

	if test_name ~= nil then
		table.insert(command_table, " run ")
		table.insert(command_table, project_name)
		table.insert(command_table, ":test")
		table.insert(command_table, ' --testPathPattern "')
		table.insert(command_table, helpers.get_file_path())
		table.insert(command_table, '" --testNamePattern=\'"')
		table.insert(command_table, test_name)
		table.insert(command_table, "\"'")
		table.insert(command_table, " --watch")

		run_cmd(command_table, opts)
	end
end

local M = {}

M.setup = function()
	user_cmd("NxTestAll", run_test_for_all_projects, { nargs = "*" })
	user_cmd("NxTest", run_test_for_project, { nargs = "*" })
	user_cmd("NxTestFile", run_test_for_file, { nargs = "*" })
	user_cmd("NxTestSingle", run_test_for_single, { nargs = "*" })
end

return M
