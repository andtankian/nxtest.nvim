local M = {}
local config = require("nxtest.config")
local cmd = vim.cmd

---@param command string The command to run in terminal
function M.open_terminal(command, debug)
	local node_options = debug and "NODE_OPTIONS=--inspect-wait" or ""
	local terminal_cmd = "terminal cd " .. vim.fn.getcwd() .. " && " .. node_options .. " " .. command

	print(vim.inspect(config))

	if config.config.terminal_position == "vertical" then
		cmd("vsplit | " .. terminal_cmd)
	elseif config.config.terminal_position == "horizontal" then
		cmd("split | " .. terminal_cmd)
	elseif config.config.terminal_position == "buffer" then
		cmd("enew | " .. terminal_cmd)
	end
end

return M

