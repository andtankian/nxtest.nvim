local M = {}
local terminal = require("nxtest.terminal")
local utils = require("nxtest.utils")

---@class CommandOpts
---@field args string Arguments passed to the command

---@param command_table string[]
---@param opts CommandOpts|nil
---@param debug boolean|nil
local function run_cmd(command_table, opts, debug)
	if opts ~= nil then
		table.insert(command_table, " " .. opts.args)
	end

	local command = table.concat(command_table, "")
	terminal.open_terminal("pnpm nx " .. command, debug)
end

---@param opts CommandOpts|nil
function M.run_test_for_all_projects(opts)
	local command_table = {}
	table.insert(command_table, " run-many -t test")
	run_cmd(command_table, opts)
end

---@param opts CommandOpts|nil
function M.run_test_for_project(opts)
	local command_table = {}
	local project_name = utils.get_nx_project_name()

	table.insert(command_table, " run ")
	table.insert(command_table, project_name)
	table.insert(command_table, ":test")

	run_cmd(command_table, opts)
end

---@param opts CommandOpts|nil
function M.run_test_for_file(opts)
	local command_table = {}
	local project_name = utils.get_nx_project_name()

	table.insert(command_table, " run ")
	table.insert(command_table, project_name)
	table.insert(command_table, ":test")
	table.insert(command_table, ' --testPathPattern="')
	table.insert(command_table, utils.get_file_path())
	table.insert(command_table, '" --watch')

	run_cmd(command_table, opts)
end

---@param command_table string[]
---@return boolean
local function build_single_test_command(command_table)
	local project_name = utils.get_nx_project_name()
	local line_number = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(0, 0, line_number, false)

	---@type string|nil
	local test_name = nil
	---@type string|nil
	local describe_context = nil

	local current_line = lines[#lines]
	local _, _, found_test_name = string.find(current_line, "^%s*%a+%(['\"](.+)['\"]")
	if found_test_name then
		test_name = found_test_name
	end

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
		table.insert(command_table, utils.get_file_path())
		table.insert(command_table, '"')

		if describe_context ~= nil then
			table.insert(command_table, " --testNamePattern='\"")
			table.insert(command_table, describe_context .. " " .. test_name)
			table.insert(command_table, "\"'")
		else
			table.insert(command_table, " --testNamePattern='\"")
			table.insert(command_table, test_name)
			table.insert(command_table, "\"'")
		end

		table.insert(command_table, " --watch")
		return true
	end
	return false
end

---@param opts CommandOpts|nil
function M.run_test_for_single(opts)
	local command_table = {}
	if build_single_test_command(command_table) then
		run_cmd(command_table, opts, false)
	end
end

---@param opts CommandOpts|nil
function M.debug_test_for_single(opts)
	local command_table = {}
	if build_single_test_command(command_table) then
		run_cmd(command_table, opts, true)
	end
end

---@param opts CommandOpts|nil
function M.run_tests_for_affected_projects(opts)
	local command_table = {}
	table.insert(command_table, " affected --target test")
	run_cmd(command_table, opts)
end

return M

