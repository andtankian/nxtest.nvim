local scan = require("plenary.scandir")

local M = {}

--[[

Checks if a given input string contains a specific search string.

Parameters:
- inputString (string): The input string to search within.
- search (string): The string to search for within the input string.

Returns:
- boolean: True if the search string is found within the input string, false otherwise.

]]
local function includesString(inputString, search)
	return string.find(inputString, search) ~= nil
end

--[[

    This function takes a string representing a file path and returns a new string representing the path without the last component (i.e., the file or directory name at the end of the path).

    Parameters:
    - path (string): A string representing a file path.

    Returns:
    - string: A new string representing the path without the last component.

]]
local function getPathWithoutLastComponent(path)
	return path:match("^(.*)/[^/]*$")
end

local function getFilePath()
	return vim.fn.expand("%:p")
end

--[[

    Recursively searches for a file named 'project.json' in the specified directory path.

    Parameters:
    - path (string): The directory path to start the search from.

    Returns:
    - string: The file path of the 'project.json' file if found.
    - None: If the 'project.json' file is not found in the specified directory path.

--]]
local function getProjectJsonPath(path)
	local result = scan.scan_dir(path)

	for _, file in ipairs(result) do
		if includesString(file, "project.json") then
			return file
		end
	end

	return getProjectJsonPath(getPathWithoutLastComponent(path))
end

--[[

    Retrieves the name of the Nx project based on the project.json file.

    This function first gets the file path of the current file being edited, then determines the path to the project.json file
    by removing the last component of the file path. It then reads the project.json file, extracts the project name from it,
    and returns the project name.

    Returns:
    - string: The name of the Nx project.
]]
local function getNxProjectName()
	local filePath = getFilePath()
	print("filePath", filePath)
	local projectJsonPath = getProjectJsonPath(getPathWithoutLastComponent(filePath))

	local projectJsonContent

	local projectJsonFile = io.open(projectJsonPath, "r")

	if projectJsonFile == nil then
		return
	end

	projectJsonContent = projectJsonFile:read("*a")
	projectJsonFile:close()

	local projectJson = vim.fn.json_decode(projectJsonContent)

	return projectJson.name
end

M.getNxProjectName = getNxProjectName
M.getFilePath = getFilePath

return M
