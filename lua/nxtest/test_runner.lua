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

	-- Define patterns for test keywords
	local it_pattern = "^%s*it%s*%(['\"](.+)['\"]"
	local test_pattern = "^%s*test%s*%(['\"](.+)['\"]"
	local describe_pattern = "^%s*describe%s*%(['\"](.+)['\"]"

	-- Check if current line matches any pattern
	local _, _, it_match = string.find(current_line, it_pattern)
	local _, _, test_match = string.find(current_line, test_pattern)
	local _, _, describe_match = string.find(current_line, describe_pattern)

	-- Set test name if we're on an it/test line
	if it_match then
		test_name = it_match
	elseif test_match then
		test_name = test_match
	elseif describe_match then
		describe_context = describe_match
	end

	-- If we're not on a describe line but on a test line, look for parent describe
	if not describe_match and (it_match or test_match) then
		for i = #lines - 1, 1, -1 do
			local _, _, found_describe = string.find(lines[i], describe_pattern)
			if found_describe then
				describe_context = found_describe
				break
			end
		end
	end

	-- Build command if we have a test or describe to run
	if test_name ~= nil or describe_match then
		table.insert(command_table, " run ")
		table.insert(command_table, project_name)
		table.insert(command_table, ":test")
		table.insert(command_table, ' --testPathPattern="')
		table.insert(command_table, utils.get_file_path())
		table.insert(command_table, '"')

		if describe_match then
			-- Run all tests in this describe block
			table.insert(command_table, " --testNamePattern='\"")
			table.insert(command_table, describe_context)
			table.insert(command_table, "\"'")
		elseif describe_context ~= nil then
			-- Run specific test with describe context
			table.insert(command_table, " --testNamePattern='\"")
			table.insert(command_table, describe_context .. " " .. test_name)
			table.insert(command_table, "\"'")
		else
			-- Run specific test without describe context
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
