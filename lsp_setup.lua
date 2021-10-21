local map = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=true }
local nvim_lsp = require'lspconfig'
function on_attach(client, bufnr)
	local function map(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	  end
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', {})
	map('n', 'U', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	map('n', '[c', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	map('n', ']c', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	map('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	--map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_command("au BufWritePost <buffer> lua vim.lsp.buf.formatting()")
end

-------------------------------------------------------------------------
--INSTALL LSP's
--_______________________________________________________________________

local servers = { 'gopls', 'rust_analyzer', 'jedi_language_server', 'sumneko_lua', 'jsonls'}
local lsp_installer_servers = require'nvim-lsp-installer.servers'

for _, srv in ipairs(servers) do
	local ok, srv = lsp_installer_servers.get_server(srv)
	if ok then
		if not srv:is_installed() then
			srv:install()
		end
	end
end



function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
-------------------------------------------------------------------------
-- completion and lsp
--_______________________________________________________________________
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)


local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	if server.name == "gopls" then
		opts.cmd = {"gopls"} -- gopls installed in gobin path
	end

	server:setup(opts)
	vim.cmd [[ do User LspAttachBuffers ]]
end)

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
})

local function goto_definition(split_cmd)
  local util = vim.lsp.util
  local log = require("vim.lsp.log")
  local api = vim.api

  --local handler = function(_, result, ctx) -- new style handles
  local handler = function(_, method, result)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(method, "No location found")
      return nil
    end
	-- get full path (remove file:// prefix)
	local name = string.sub(result[1]['uri'], 8)
	-- find window(split) with this buffer
	local winid = vim.fn.bufwinid(name);
	-- if exists jump to it
	if winid ~= nil then
		vim.fn.win_gotoid(winid)
	end

    if vim.tbl_islist(result) then
      util.jump_to_location(result[1])
      if #result > 1 then
        util.set_qflist(util.locations_to_items(result))
        api.nvim_command("copen")
        api.nvim_command("wincmd p")
      end
    else
		-- jump to location
		util.jump_to_location(result)
    end
  end

  return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition('split')


vim.o.completeopt = 'menuone,noselect,noinsert'
local luasnip = require 'luasnip'
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<A-k>'] = cmp.mapping.select_prev_item(),
    ['<A-j>'] = cmp.mapping.select_next_item(),
    ['<A-S-k>'] = cmp.mapping.scroll_docs(-4),
    ['<A-S-j>'] = cmp.mapping.scroll_docs(4),
    ['<A-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
	['<CR>'] = cmp.mapping.confirm {
	  behavior = cmp.ConfirmBehavior.Replace,
	  select = true,
	},
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.confirm()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
		  cmp.confirm()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-------------------------------------------------------------------------
-- bufferline
--_______________________________________________________________________
vim.opt.termguicolors = true
require("bufferline").setup{
	diagnostics = "nvim_lsp",
}

map('n', '<A-l>', ":BufferLineCycleNext<CR>", opts)
map('n', '<A-h>', ":BufferLineCyclePrev<CR>", opts)
map('n', '<A-w>', ":w<CR>:bdelete<CR>", opts)


-------------------------------------------------------------------------
-- telescope
--_______________________________________________________________________
local themes = require('telescope.themes')
require('telescope').setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
		  ["<A-j>"] = "move_selection_next",
		  ["<A-k>"] = "move_selection_previous",
      },
	  n = {
	  }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}
map('n', 'gr', ":lua require'telescope.builtin'.lsp_references{}<CR>",opts)
map('n', '<leader>qf', ":lua require'telescope.builtin'.lsp_code_actions(require'telescope.themes'.get_cursor())<CR>",opts)
map('n', 'gi', ":lua require'telescope.builtin'.lsp_implementations{}<CR>",opts)
map('n', '<A-S-f>', ":lua require'telescope.builtin'.live_grep{}<CR>",opts)
map('n', '<A-S-o>', ":lua require'telescope.builtin'.find_files{}<CR>",opts)
map('n', '<A-S-q>', ":lua require'telescope.builtin'.quickfix{}<CR>",opts)
-- <C-d> - preview down
-- <C-u> - preview up


-------------------------------------------------------------------------
-- nvim tree
--_______________________________________________________________________
require'nvim-tree'.setup {
	diagnostics = {
		enable = true,
		icons = {
		  hint = "",
		  info = "",
		  warning = "",
		  error = "",
		}
	},
	update_focused_file = {
		enable      = true,
	},
	view = {
		width = 40,
	}
}
map('n', "<C-n>", "<cmd>NvimTreeToggle<CR>", opts)

-------------------------------------------------------------------------
-- treesitter
--_______________________________________________________________________

local ts = require('nvim-treesitter.configs')
ts.setup {
	ensure_installed = {"python", "go"},
	highlight = {
		enable = true,
	}
}
