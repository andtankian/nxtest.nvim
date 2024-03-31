local utils = require("utils")

local cmd = vim.cmd
local usercmd = vim.api.nvim_create_user_command

local function runCmd(command)
	cmd("vsplit | terminal cd " .. vim.loop.cwd() .. " && pnpm nx run " .. command)
end

local function runTestForProject()
	local projectName = utils.getNxProjectName()
	local command = projectName .. ":test" .. " --watch"
	runCmd(command)
end

local function runTestForFile()
	local projectName = utils.getNxProjectName()
	local command = projectName .. ":test --runTestsByPath " .. '"' .. utils.getFilePath() .. '"' .. " --watch"
	runCmd(command)
end

local function runTestForSingle()
	local projectName = utils.getNxProjectName()

	local line = vim.api.nvim_get_current_line()
	local _, _, testName = string.find(line, "^%s*%a+%(['\"](.+)['\"]")

	if testName ~= nil then
		local command = projectName
			.. ":test --runTestsByPath "
			.. '"'
			.. utils.getFilePath()
			.. '"'
			.. ' --testNamePattern=\'"'
			.. testName
			.. '"\' --watch'
		runCmd(command)
	end
end

local M = {}

M.setup = function()
	usercmd("NxTest", runTestForProject, { nargs = 0 })
	usercmd("NxTestFile", runTestForFile, { nargs = 0 })
	usercmd("NxTestSingle", runTestForSingle, { nargs = 0 })
end

return M
