local scan = require("plenary.scandir")

local M = {}

--[[

Checks if a given input string contains a specific search string.

Parameters:
- input_string (string): The input string to search within.
- search (string): The string to search for within the input string.

Returns:
- boolean: True if the search string is found within the input string, false otherwise.

]]
local function includes_string(input_string, search)
  return string.find(input_string, search) ~= nil
end

--[[

    This function takes a string representing a file path and returns a new string representing the path without the last component (i.e., the file or directory name at the end of the path).

    Parameters:
    - path (string): A string representing a file path.

    Returns:
    - string: A new string representing the path without the last component.

]]
local function get_path_without_last_component(path)
  return path:match("^(.*)/[^/]*$")
end

local function get_file_path()
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
local function get_project_json_path(path)
  local result = scan.scan_dir(path)

  for _, file in ipairs(result) do
    if includes_string(file, "project.json") then
      return file
    end
  end

  return get_project_json_path(get_path_without_last_component(path))
end

--[[

    Retrieves the name of the Nx project based on the project.json file.

    This function first gets the file path of the current file being edited, then determines the path to the project.json file
    by removing the last component of the file path. It then reads the project.json file, extracts the project name from it,
    and returns the project name.

    Returns:
    - string: The name of the Nx project.
]]
local function get_nx_project_name()
  local file_path = get_file_path()
  local project_json_path = get_project_json_path(get_path_without_last_component(file_path))

  local project_json_content

  local project_json_file = io.open(project_json_path, "r")

  if project_json_file == nil then
    return
  end

  project_json_content = project_json_file:read("*a")
  project_json_file:close()

  local project_json = vim.fn.json_decode(project_json_content)

  return project_json.name
end

M.get_nx_project_name = get_nx_project_name
M.get_file_path = get_file_path

return M
