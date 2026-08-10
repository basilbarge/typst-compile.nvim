local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values

local M = {}

local compile_formats = { "pdf", "png", "svg", "html", "bundle" }

local generate_command = function(opts)
	local cmd = "typst compile"

	local path = opts.file_path or vim.fn.expand("%")
	local extension = path:match("^.+(%..+)$")
	local path_head = path:match("(.*/)") or path:match("(.*\\)") or ""

	if extension ~= ".typ" then
		vim.notify("The current file is not a typst file")
		return
	end

	local format = opts.format or "pdf"
	local compiled_name = opts.compiled_name or vim.fn.expand("%:r")

	cmd = cmd .. " " .. path .. " " .. path_head .. compiled_name .. "." .. format

	print(vim.inspect(cmd))
	return cmd
end

local format_picker = function(opts)
	opts = opts or {}
	pickers.new(opts.theme, {
		prompt_title = "Formats",
		finder = finders.new_table {
			results = compile_formats
		},
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				vim.ui.input({ prompt = "Enter new file name: " }, function(input)
					if input == "" then
						input = nil
					end

					local gen_opts = {
						file_path = opts.args[1],
						format = selection[1],
						compiled_name = input
					}

					local typst_cmd = generate_command(gen_opts)

					if typst_cmd ~= nil then
						local cmd = "silent :!" .. typst_cmd
						vim.cmd(cmd)
					end
				end)
			end)
			return true
		end
	}):find()
end

M.setup = function()
	vim.api.nvim_create_user_command("TypstCompile", function(opts)
		format_picker({ theme = (require "telescope.themes").get_dropdown(), args = opts.fargs })
	end, { nargs = "?" })
end

return M
