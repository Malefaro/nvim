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

"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'preservim/nerdtree' |
            "\ Plug 'Xuyuanp/nerdtree-git-plugin'

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
Plug 'puremourning/vimspector'
Plug 'tweekmonster/django-plus.vim'
Plug 'preservim/tagbar'
Plug 'tpope/vim-fugitive'
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

"colorscheme gruvbox
" color dracula
"let g:airline#extensions#hunks#enabled=0
"let g:airline#extension#branch#enabled=1
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

"" Nerd tree mapping
"map <C-n> : NERDTreeToggle<CR>

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
nmap <ESC> :nohlsearch<CR>

nnoremap <A-S-o> :Files<CR>
nnoremap <A-S-f> :Ag 
nnoremap <A-w> :w<CR><CR>:tabclose<CR>

" jump tabs
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

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

" Vimspectore
"
nmap <leader>vb <Plug>VimspectorToggleBreakpoint
nmap <leader>vc <Plug>VimspectorContinue
nmap <leader>ve <Plug>VimspectorStop
nmap ]d <Plug>VimspectorStepOver
nmap [d <Plug>VimspectorStepOut
nmap <leader>vi <Plug>VimspectorStepInto


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
