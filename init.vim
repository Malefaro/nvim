set nocompatible

set termencoding=UTF-8
set encoding=UTF-8

set backspace=2
set shiftwidth=4
set softtabstop=4
set tabstop=4
"set expandtab
set autoread
" line length
set colorcolumn=119

autocmd TextChanged,TextChangedI <buffer> silent write

set number

syntax enable

set mouse=a
set mousemodel=popup
set cursorline

set hlsearch
set incsearch

filetype plugin on

set list
" set listchars=tab:>-
set clipboard+=unnamedplus
let g:mapleader=','

call plug#begin(stdpath('data') . '/plugged')

" Color scheme
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'crusoexia/vim-monokai'

Plug 'fatih/vim-go'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdcommenter'
Plug 'mhinz/vim-startify'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'tweekmonster/django-plus.vim'
Plug 'preservim/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'hoob3rt/lualine.nvim'
" debugger
Plug 'mfussenegger/nvim-dap'
" tests
Plug 'vim-test/vim-test'
Plug 'rcarriga/vim-ultest', { 'do': ':UpdateRemotePlugins' }
Plug 'xiyaowong/nvim-transparent'
call plug#end()

let g:coc_global_extensions = [
      \'coc-markdownlint',
      \'coc-highlight',
      \'coc-go',
      \'coc-jedi',
      \'coc-python',
      \'coc-json',
      \'coc-explorer',
	  \'coc-rust-analyzer',
      \]
" colorscheme dracula
colorscheme monokai
"colorscheme gruvbox


"------------------------------------
" vim go
"------------------------------------
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_def_mapping_enabled = 0
let g:go_code_completion_enabled = 0
let g:go_doc_keywordprg_enabled = 0
"-------------------------------------

" coc-explorer
map <C-n> :CocCommand explorer<CR>


nmap <leader>nhl :nohlsearch<CR>


" Tagbar
nmap <F8> :TagbarToggle<CR>


map <Leader> <Plug>(easymotion-prefix)

inoremap <expr><A-j> pumvisible() ? "\<Down>" : "\<C-n>"
inoremap <expr><A-k> pumvisible() ? "\<Up>" : "\<C-p>"

" select in somethink like :Ag, :Files 
tmap <A-j> <Down>
tmap <A-k> <Up>

nmap J 5j
nmap K 5k

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nmap <A-l>  gt<ESC>
nmap <A-h>  gT<ESC>
nmap <silent> <ESC> :nohlsearch<CR>

nnoremap <A-S-o> :Files<CR>
nnoremap <A-S-f> :Ag 
nnoremap <A-w> :w<CR><CR>:tabclose<CR>
nnoremap <A-s> :w<CR>

" jump tabs
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

command Reload :source ~/.config/nvim/init.vim
au BufWritePost *.go :silent !gofmt -w %
autocmd BufWritePost *.go edit
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
"au filetype go inoremap <buffer> . .<C-x><C-o>
set completeopt+=noinsert

" GitGutter
nmap <leader>hp <Plug>(GitGutterPreviewHunk)
nmap <leader>hu <Plug>(GitGutterUndoHunk)
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)


" nvim-dap
" -----------------------------------------------------------------------------------------
nnoremap <silent> <leader>dc :lua require'dap'.continue()<CR>
nnoremap <silent> ]d :lua require'dap'.step_over()<CR>
nnoremap <silent> [d :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>l :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>db :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
	" end
nnoremap <silent> <leader>de :lua require'dap'.disconnect()<CR>:lua require'dap'.close()<CR>
	" list breakpoints
nnoremap <silent> <leader>dl :lua require'dap'.list_breakpoints()<CR>:copen<CR>
" end nvim-dap
" -----------------------------------------------------------------------------------------
" ___________________________________________________________________________________
" LUA
" ___________________________________________________________________________________
lua <<EOF
require('lualine').setup()
require("transparent").setup({
  enable = true,
})

local widgets = require('dap.ui.widgets')
local scopes_sidebar = widgets.sidebar(widgets.scopes, {}, "45 vsplit")
local frames_sidebar = widgets.sidebar(widgets.frames, {}, "rightbelow 30 vsplit")
local dap = require('dap')
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
local repl = dap.repl
function setupDebug()
	scopes_sidebar.open()
	frames_sidebar.open()
	repl.open()
end

function closeDebug()
	scopes_sidebar.close()
	frames_sidebar.close()
	repl.close()
end
EOF

" ___________________________________________________________________________________
" END OF LUA
" ___________________________________________________________________________________
nnoremap <silent> <leader>ds :lua setupDebug()<CR>
nnoremap <silent> <leader>dx :lua closeDebug()<CR>

" vim-test
"nmap <silent> <leader>tn :TestNearest<CR>
"nmap <silent> <leader>tf :TestFile<CR>
let test#go#gotest#options = "-count=1 -timeout=60s -v"
nmap <leader>tn <Plug>(ultest-run-nearest)
nmap <leader>td <Plug>(ultest-debug-nearest)
nmap <leader>ts <Plug>(ultest-summary-toggle)
nmap <leader>to <Plug>(ultest-output-jump)
nmap <leader>ta <Plug>(ultest-attach)
nmap <leader>tf <Plug>(ultest-run-file)
	" end
nmap <leader>te <Plug>(ultest-stop-file)

" ___________________________________________________________________________________
" LUA dap
" ___________________________________________________________________________________

lua <<EOF
local dap = require('dap')
dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
      stdio = {nil, stdout},
      args = {"dap", "-l", "127.0.0.1:" .. port},
      detached = true
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print('dlv exited with code', code)
      end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require('dap.repl').append(chunk)
        end)
      end
    end)
    -- Wait for delve to start
    vim.defer_fn(
      function()
        callback({type = "server", host = "127.0.0.1", port = port})
      end,
      100)
  end
  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}"
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}"
    },
    -- works with go.mod packages and sub packages 
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    } 
}

require("ultest").setup({
	builders = {
	  ['python#pytest'] = function (cmd)
		-- The command can start with python command directly or an env manager
		local non_modules = {'python', 'pipenv', 'poetry'}
		-- Index of the python module to run the test.
		local module
		if vim.tbl_contains(non_modules, cmd[1]) then
		  module = cmd[3]
		else
		  module = cmd[1]
		end
		-- Remaining elements are arguments to the module
		local args = vim.list_slice(cmd, module_index + 1)
		return {
		  dap = {
			type = 'python',
			request = 'launch',
			module = module,
			args = args
		  }
		}
	  end,
	  ["go#gotest"] = function(cmd)
		local args = {}
		for i = 3, #cmd - 1, 1 do
		  local arg = cmd[i]
		  if vim.startswith(arg, "-") then
			-- Delve requires test flags be prefix with 'test.'
			arg = "-test." .. string.sub(arg, 2)
		  end
		  args[#args + 1] = arg
		end
		return {
		  dap = {
			type = "go",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
			dlvToolPath = vim.fn.exepath("dlv"),
			args = args
		  },
		  parse_result = function(lines)
			return lines[#lines] == "FAIL" and 1 or 0
		  end
		}
	  end
	}
})

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

EOF


" ___________________________________________________________________________________
" END OF LUA
" ___________________________________________________________________________________







"__________________________________________________________
" coc-highlight
autocmd CursorHold * silent call CocActionAsync('highlight')

" -------------------------------------------------------------------------------------------------
" coc.nvim default settings
" -------------------------------------------------------------------------------------------------

" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes



" select placeholders
"let g:coc_snippet_next = '<TAB>'
"let g:coc_snippet_prev = '<S-TAB>'
"
"
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB> pumvisible() ? coc#_select_confirm() : 
                                            \ <SID>check_back_space() ? "\<TAB>" :
                                            \ coc#refresh()
                                           "\"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"inoremap <silent><expr> <TAB>
      "\ pumvisible() ? "\<C-n>" :
      "\ <SID>check_back_space() ? "\<TAB>" :
      "\ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <A-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf <Plug>(coc-fix-current)

" Remap for format selected region
map <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" coc-go
autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>
