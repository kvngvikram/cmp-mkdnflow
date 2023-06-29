
local mkdnflow_root_dir = require('mkdnflow').root_dir  -- String
-- local mkdnflow_root_dir = '../..'
-- local mkdnflow_root_dir = 'asdfasdfasdfsadfasdf'
local plenary_scandir = require('plenary').scandir.scan_dir  -- Function
local cmp = require('cmp')
-- local plenary_path = require('plenary').path
local extension = '.md'  -- keep the .


local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end


-- local function get_files_items()
function source:complete(params, callback)
	-- local filepaths_in_root = plenary_scandir(mkdnflow_root_dir)
	local filepaths_in_root = plenary_scandir(mkdnflow_root_dir)
	local items = {}
	for _, path in ipairs(filepaths_in_root) do
		if vim.endswith(path, extension) then
			local item = {}
			item.path = path  -- absolute path of the file
			-- we are getting absolute path from root from plenary_scandir
			-- So remove the mkdnflow_root_dir from it
			item.path_from_root = path:gsub(mkdnflow_root_dir..'/', '')
			-- need only the filename without extension
			item.label = path:match('([a-zA-Z0-9 -]+)'..extension..'$')
			-- text should be inserted in fmarkdown format
			item.insertText = '['..item.label..']('..item.path_from_root..')'
			-- for butification
			item.kind = cmp.lsp.CompletionItemKind.File

			table.insert(items, item)
		end
	end
	-- return items
	callback(items)
end

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

	completion_item.documentation = { kind = cmp.lsp.MarkupKind.Markdown, value = first_kb }
	callback(completion_item)
end


return source
