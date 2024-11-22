---@type table
local scan = require("plenary.scandir")

---@param input_string string The input string to search within
---@param search string The string to search for within the input string
---@return boolean True if the search string is found within the input string
local function includes_string(input_string, search)
	return string.find(input_string, search) ~= nil
end

---@param path string A string representing a file path
---@return string path The path without the last component
local function get_path_without_last_component(path)
	return path:match("^(.*)/[^/]*$")
end

---@return string file_path The full path of the current buffer
local function get_file_path()
	return vim.fn.expand("%:p")
end

---@param path string The directory path to start the search from
---@return string project_json_path The file path of the project.json file if found
local function get_project_json_path(path)
	---@type string[]
	local result = scan.scan_dir(path)

	for _, file in ipairs(result) do
		if includes_string(file, "project.json") then
			return file
		end
	end

	return get_project_json_path(get_path_without_last_component(path))
end

---@class NxProject
---@field name string The name of the Nx project

---@return string? project_name The name of the Nx project
local function get_nx_project_name()
	local file_path = get_file_path()
	local project_json_path = get_project_json_path(get_path_without_last_component(file_path))

	local project_json_content

	---@type file*?
	local project_json_file = io.open(project_json_path, "r")

	if project_json_file == nil then
		return nil
	end

	project_json_content = project_json_file:read("*a")
	project_json_file:close()

	---@type NxProject
	local project_json = vim.fn.json_decode(project_json_content)

	return project_json.name
end

---@class Helpers
---@field get_file_path fun(): string
---@field get_nx_project_name fun(): string?
local Helpers = {
	get_file_path = get_file_path,
	get_nx_project_name = get_nx_project_name,
}

return Helpers
