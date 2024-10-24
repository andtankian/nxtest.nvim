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

	local project_name = helpers.get_nx_project_name()

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

	local line_number = vim.api.nvim_win_get_cursor(0)[1] -- current line number
	local lines = vim.api.nvim_buf_get_lines(0, 0, line_number, false)

	-- Initialize variables to hold the test name and describe context
	local test_name = nil
	local describe_context = nil

	-- Extract test name from the current line
	local current_line = lines[#lines]
	local _, _, found_test_name = string.find(current_line, "^%s*%a+%(['\"](.+)['\"]")
	if found_test_name then
		test_name = found_test_name
	end

	-- Traverse upward to find the nearest 'describe' block
	for i = #lines - 1, 1, -1 do
		_, _, describe_context = string.find(lines[i], "^%s*describe%s*%(['\"](.+)['\"]")
		if describe_context then
			break
		end
	end

	if test_name ~= nil then
		table.insert(command_table, " run ")
		table.insert(command_table, project_name)
		table.insert(command_table, ":test")
		table.insert(command_table, ' --testPathPattern="')
		table.insert(command_table, helpers.get_file_path())
		table.insert(command_table, '"')

		-- Add both the describe context and the test name to the testNamePattern
		if describe_context ~= nil then
			table.insert(command_table, " --testNamePattern='\"")
			table.insert(command_table, describe_context .. " " .. test_name)
			table.insert(command_table, "\"'")
		else
			-- Fallback to just test name if no describe context found
			table.insert(command_table, " --testNamePattern='\"")
			table.insert(command_table, test_name)
			table.insert(command_table, "\"'")
		end

		table.insert(command_table, " --watch")

		run_cmd(command_table, opts)
	end
end

local function run_tests_for_affected_projects(opts)
	local command_table = {}

	table.insert(command_table, " affected --target test")

	run_cmd(command_table, opts)
end

local M = {}

M.setup = function()
	user_cmd("NxTest", run_test_for_project, { nargs = "*" })
	user_cmd("NxTestAffected", run_tests_for_affected_projects, { nargs = "*" })
	user_cmd("NxTestAll", run_test_for_all_projects, { nargs = "*" })
	user_cmd("NxTestFile", run_test_for_file, { nargs = "*" })
	user_cmd("NxTestSingle", run_test_for_single, { nargs = "*" })
end

return M
