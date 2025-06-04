local treesitter_context_ctx = require("treesitter-context.context")
local diag_counter_cache = {}
local diag_cursor_line_cache = {}

vim.fn.sign_define("DiagnosticSignError", {
  text = "󰅚 ",
  texthl = "DiagnosticSignError",
  numhl = "DiagnosticSignError"
})
vim.fn.sign_define("DiagnosticSignWarn", {
  text = "󰀪 ",
  texthl = "DiagnosticSignWarn",
  numhl = "DiagnosticSignWarn"
})
vim.fn.sign_define("DiagnosticSignHint", {
  text = "󰌶 ",
  texthl = "DiagnosticSignHint",
  numhl = "DiagnosticSignHint"
})
vim.fn.sign_define("DiagnosticSignInfo", {
  text = " ",
  texthl = "DiagnosticSignInfo",
  numhl = "DiagnosticSignInfo"
})

local diag_sign_warn = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text:gsub("%s+", "")
local diag_sign_error = vim.fn.sign_getdefined("DiagnosticSignError")[1].text:gsub("%s+", "")
local diag_sign_info = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text:gsub("%s+", "")
local diag_sign_hint = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text:gsub("%s+", "")

vim.fn.sign_define("DiagSummaryBottom", { text = "▼", texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagSummaryTop", { text = "▲", texthl = "DiagnosticSignHint" })

local function update_diag_summary()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo.buftype ~= "" or vim.fn.bufname(bufnr) == "" then
		vim.fn.sign_unplace("DiagSummaryGroup", { buffer = bufnr })
		return
	end

	local cursor_line_current = vim.api.nvim_win_get_cursor(0)[1]
	if diag_cursor_line_cache[bufnr] and diag_cursor_line_cache[bufnr] == cursor_line_current then
		return
	end
	diag_cursor_line_cache[bufnr] = cursor_line_current

	local winid = vim.api.nvim_get_current_win()
	local context_ranges, _ = treesitter_context_ctx.get(winid)

	local diags = vim.diagnostic.get(bufnr)

	-- get window‐relative top and bottom line numbers (1-indexed)
	local lines_in_context = 0
	-- Context ranges: { { 0, 0, 7, 0 }, { 45, 0, 46, 0 }, { 46, 0, 47, 0 }, { 47, 0, 48, 0 }, { 65, 0, 66, 0 } }
	if context_ranges ~= nil then
		for _, range in ipairs(context_ranges) do
			lines_in_context = lines_in_context + (range[3] - range[1])
		end
	end
	local top = vim.fn.line("w0") + lines_in_context
	local bot = vim.fn.line("w$")

	local counters = {
		above = { error = 0, warn = 0, info = 0, hint = 0 },
		below = { error = 0, warn = 0, info = 0, hint = 0 },
	}

	for _, d in ipairs(diags) do
		if d.lnum + 1 < top then
			if d.severity == vim.diagnostic.severity.ERROR then
				counters.above.error = counters.above.error + 1
			elseif d.severity == vim.diagnostic.severity.WARN then
				counters.above.warn = counters.above.warn + 1
			elseif d.severity == vim.diagnostic.severity.INFO then
				counters.above.info = counters.above.info + 1
			else
				counters.above.hint = counters.above.hint + 1
			end
		elseif d.lnum + 1 > bot then
			if d.severity == vim.diagnostic.severity.ERROR then
				counters.below.error = counters.below.error + 1
			elseif d.severity == vim.diagnostic.severity.WARN then
				counters.below.warn = counters.below.warn + 1
			elseif d.severity == vim.diagnostic.severity.INFO then
				counters.below.info = counters.below.info + 1
			else
				counters.below.hint = counters.below.hint + 1
			end
		end
	end

	local function format_number(number, icon)
		if number > 9 then
			return ">" .. icon
		else
			return string.format("%d" .. icon, number)
		end
	end

	local position_bot, position_top = 0, 0
	for _, entry in pairs({
		{ "TopError", counters.above.error, 1, diag_sign_error or "" },
		{ "TopWarning", counters.above.warn, 2, diag_sign_warn or "" },
		{ "TopInfo", counters.above.info, 3, diag_sign_info or "" },
		{ "TopHint", counters.above.hint, 4, diag_sign_hint or "" },
		{ "BelowError", counters.below.error, 5, diag_sign_error or "" },
		{ "BelowWarning", counters.below.warn, 6, diag_sign_warn or "" },
		{ "BelowInfo", counters.below.info, 7, diag_sign_info or "" },
		{ "BelowHint", counters.below.hint, 8, diag_sign_hint or "" },
	}) do
		local group, count, id, icon = entry[1], entry[2], entry[3], entry[4]
		local name = "DiagSummary" .. group

		if diag_counter_cache[bufnr] and diag_counter_cache[bufnr][id] then
			-- redraw the sign on the updated line number
			if count == 0 then
				if diag_counter_cache[bufnr][id] ~= 0 then
					-- vim.fn.sign_undefine(name)
					vim.fn.sign_unplace("DiagSummaryGroup", { buffer = bufnr, name = name })
				end

				diag_counter_cache[bufnr][id] = count
				goto continue
			end

			if diag_counter_cache[bufnr][id] ~= count then
				diag_counter_cache[bufnr][id] = count
			end
		elseif not diag_counter_cache[bufnr] then
			diag_counter_cache[bufnr] = {}
			diag_counter_cache[bufnr][id] = count
			if count == 0 then
				goto continue
			end
		elseif diag_counter_cache[bufnr][id] == nil then
			diag_counter_cache[bufnr][id] = count
			if count == 0 then
				goto continue
			end
		end

		local texthl
		if group:find("Error") then
			texthl = "DiagnosticSignError"
		elseif group:find("Warning") then
			texthl = "DiagnosticSignWarn"
		elseif group:find("Info") then
			texthl = "DiagnosticSignInfo"
		else
			texthl = "DiagnosticSignHint"
		end
		-- Define a new sign named {name} or modify the attributes of an existing sign.
		vim.fn.sign_define(name, { text = format_number(count, icon), texthl = texthl })

		local is_top = group:find("Top")
		local lnum
		if is_top then
			lnum = top + position_top
			position_top = position_top + 1
		else
			lnum = bot - position_bot
			position_bot = position_bot + 1
		end
		vim.fn.sign_place(id, "DiagSummaryGroup", name, bufnr, { lnum = lnum, priority = 50 })

		::continue::
	end

	if position_top > 0 then
		vim.fn.sign_place(9, "DiagSummaryGroup", "DiagSummaryTop", bufnr, { lnum = top + position_top, priority = 5 })
	else
		vim.fn.sign_unplace("DiagSummaryGroup", { buffer = bufnr, name = "DiagSummaryTop" })
	end
	if position_bot > 0 then
		vim.fn.sign_place(
			10,
			"DiagSummaryGroup",
			"DiagSummaryBottom",
			bufnr,
			{ lnum = bot - position_bot, priority = 5 }
		)
	else
		vim.fn.sign_unplace("DiagSummaryGroup", { buffer = bufnr, name = "DiagSummaryBottom", priority = 5 })
	end
end

vim.api.nvim_create_autocmd({ "WinScrolled", "CursorMoved", "BufEnter" }, {
	callback = update_diag_summary,
})
