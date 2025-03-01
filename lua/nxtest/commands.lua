local M = {}
local test_runner = require("nxtest.test_runner")

function M.setup()
	local user_cmd = vim.api.nvim_create_user_command

	user_cmd("NxTest", test_runner.run_test_for_project, { nargs = "*" })
	user_cmd("NxTestAffected", test_runner.run_tests_for_affected_projects, { nargs = "*" })
	user_cmd("NxTestAll", test_runner.run_test_for_all_projects, { nargs = "*" })
	user_cmd("NxTestFile", test_runner.run_test_for_file, { nargs = "*" })
	user_cmd("NxTestSingle", test_runner.run_test_for_single, { nargs = "*" })
	user_cmd("NxTestDebugSingle", test_runner.debug_test_for_single, { nargs = "*" })
end

return M
