local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values

local M = {}

local compile_formats = { "pdf", "png", "svg", "html", "bundle" }


local format_picker = function(opts)
	opts = opts or {}
	pickers.new(opts, {
		prompt_title = "Formats",
		finder = finders.new_table {
			results = compile_formats
		},
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				print(vim.inspect(selection))
			end)
			return true
		end
	}):find()
end

--format_picker((require "telescope.themes").get_dropdown())

local generate_command = function(file_path)
	local cmd = "typst compile"

	local path = file_path or vim.fn.expand("%")
	local extension = path:match("^.+(%..+)$")

	if extension ~= ".typ" then
		print("The current file is not a typst file")
		return
	end

	cmd = cmd .. " " .. path

	return cmd
end


M.setup = function()
	vim.api.nvim_create_user_command("TypstCompile", function()
		local cmd = generate_command()
		vim.cmd(cmd)
	end, {})
end

return M
