---@class Config
---@field terminal_position "vertical"|"horizontal"|"buffer"
local M = {
	default_config = {
		terminal_position = "buffer",
	},
	config = {},
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.default_config, opts or {})
end

return M

