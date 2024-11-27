local M = {}
local config = require("nxtest.config")
local commands = require("nxtest.commands")

---@param opts? Config
function M.setup(opts)
	config.setup(opts)
	commands.setup()
end

return M

