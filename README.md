# cmp-mkdnflow


A *nvim-cmp* source for [jakewvincent/mkdnflow.nvim](https://github.com/jakewvincent/mkdnflow.nvim). Autocompletion in insert mode when the word you are typing matches any of the *.md* files in the notebook.

Install using `packer.nvim` using this entry
```lua
use {
	'kvngvikram/cmp-mkdnflow',
	requires = { {'jakewvincent/mkdnflow.nvim'} }
}
```

Add this sources into the list of sources in your config file.
```lua
cmp.setup({
	sources = cmp.config.sources({
		----- Rest of the sources
		----- Rest of the sources
		----- Rest of the sources
		----- Rest of the sources

		{ name = 'mkdnflow' },  -- new source
	}),
})
```

Also, don't forget to edit your `formatting` options in `cmp.setup`.


# Issues

- how does it work with `transform_implicit` options of links. 
- File names cannot contain symbols and unicode characters.. Did not tune the regex well enough for that.

# Notes

I also use this telescope mapping to jump between different links in notebook

```lua
-- Telescope find files in notebook
-- got idea from https://stackoverflow.com/a/73290052
vim.keymap.set('n', '<Leader>k', function()
	if vim.o.filetype == 'markdown' then
		local root_dir = require('mkdnflow').root_dir
		if root_dir then  -- if the dir is not nil
			return ':Telescope find_files search_dirs={"'..root_dir..'"}<CR>'
		end
	end
end, {expr = true, replace_keycodes = true})
```
