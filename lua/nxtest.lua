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
	local command = projectName .. ":test " .. '"' .. utils.getFilePath() .. '"' .. " --watch"
	runCmd(command)
end

local M = {}

M.setup = function()
	usercmd("NxTest", runTestForProject, { nargs = 0 })
	usercmd("NxTestFile", runTestForFile, { nargs = 0 })
end

return M
