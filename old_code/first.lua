print('hello')

local cmp = require('cmp')

local function get_files_manual(dir_name, extension, items_table)
	items_table = items_table or {}
	extension = extension or '.md'
	local uv_fs_t, errror_sd = vim.loop.fs_scandir(dir_name)
	if not errror_sd then
		while true do
			local name, fs_type, error_sdn = vim.loop.fs_scandir_next(uv_fs_t)
			if name and not error_sdn then
				if fs_type == 'file' then
					if vim.endswith(name, extension) then
						local path = dir_name..'/'..name
						local item = {
							label = name,
						    path = path,
							insertText = path,
						    kind = cmp.lsp.CompletionItemKind.File,
						}
						table.insert(items_table, item)
					end
				elseif fs_type == 'directory' then
					items_table = get_files_manual(dir_name..'/'..name, extension, items_table)
				end
			else
				break
			end
		end
	end
	return items_table
end


---------------------------------------------------------------


local mkdnflow_root_dir = require('mkdnflow').root_dir  -- String
local plenary_scandir = require('plenary').scandir.scan_dir  -- Function

print(vim.inspect(plenary_scandir('.')))

local function get_files_items()
	-- local filepaths_in_root = plenary_scandir(mkdnflow_root_dir)
	local filepaths_in_root = plenary_scandir('.')
	local items = {}
	for _, path in ipairs(filepaths_in_root) do
		print(path)
	end
	return items
end
local items = get_files_items()


local source = {}

---Return whether this source is available in the current context or not (optional).
-- ---@return boolean
function source:is_available()
  return true
end

---Return the debug name of this source (optional).
-- ---@return string
function source:get_debug_name()
  return 'mkdnflow'
end

---Return LSP's PositionEncodingKind.
-- ---@NOTE: If this method is ommited, the default value will be `utf-16`.
-- ---@return lsp.PositionEncodingKind
function source:get_position_encoding_kind()
  return 'utf-16'
end

---Return the keyword pattern for triggering completion (optional).
---If this is ommited, nvim-cmp will use a default keyword pattern. See |cmp-config.completion.keyword_pattern|.
-- ---@return string
function source:get_keyword_pattern()
  return [[\k\+]]
end

---Return trigger characters for triggering completion (optional).
function source:get_trigger_characters()
  return { '.' }
end

---Invoke completion (required).
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
	callback(get_files_manual('.'))
end

---Resolve completion item (optional). This is called right before the completion is about to be displayed.
---Useful for setting the text shown in the documentation window (`completion_item.documentation`).
-- ---@param completion_item lsp.CompletionItem
-- ---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:resolve(completion_item, callback)

	local filepath = completion_item.path
	local binary = assert(io.open(filepath, 'rb'))
	local first_kb = binary:read(1024)

	local contents = {}
	if first_kb then  -- if its not empty file
		for content in first_kb:gmatch("[^\r\n]+") do
			table.insert(contents, content)
		end
	end

	completion_item.documentation = { kind = cmp.lsp.MarkupKind.Markdown, value = table.concat(contents, '\n') }
	callback(completion_item)
end

---Executed after the item was selected.
-- ---@param completion_item lsp.CompletionItem
-- ---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:execute(completion_item, callback)
  callback(completion_item)
end

---Register your source to nvim-cmp.
require('cmp').register_source('mkdnflow', source)


local folder = '.'
local items_table = get_files_manual(folder)
print(vim.inspect(items_table))

local bla = { name = 'blaname', path = 'blapath'}

local cmp = require('cmp')
cmp.setup({
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
		{ name = 'mkdnflow' },
	}),
})



local Path = require "plenary.path"
local abspath = "/home/happy/Desktop/mkdnflow-cmp/temp"
local cwd = "/home/happy/Desktop/mkdnflow-cmp"
    
local relpath = Path:new(abspath):make_relative(cwd)

print(relpath)

