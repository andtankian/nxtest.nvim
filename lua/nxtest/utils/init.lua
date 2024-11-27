local M = {}

---@return string file_path The full path of the current buffer
function M.get_file_path()
	return vim.fn.expand("%:p")
end

---@return string? project_name The name of the Nx project
function M.get_nx_project_name()
	local project = require("nxtest.utils.project")
	return project.get_nx_project_name()
end

return M

