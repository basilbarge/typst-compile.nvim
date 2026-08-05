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

local call_command = function()
	local cmd = {}
	for w in string.gmatch("touch test.txt", "([^" .. "%s" .. "]+)") do
		table.insert(cmd, w)
	end

	local obj = vim.system(cmd)

	print(vim.inspect(obj))
end

call_command()

M.setup = function()
end

return M
