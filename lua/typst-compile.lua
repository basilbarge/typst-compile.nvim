local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
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
	}):find()
end

format_picker((require "telescope.themes").get_dropdown())

M.setup = function()
end

return M
