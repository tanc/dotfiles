" Declare the general config group for autocommand
augroup vimrc
  autocmd!
augroup END

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

let mapleader = "\<Space>"

" Set up minpac
packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})

" Various plugins
call minpac#add('patstockwell/vim-monokai-tasty')
call minpac#add('ntpeters/vim-better-whitespace')
call minpac#add('pangloss/vim-javascript')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('tpope/vim-obsession')
call minpac#add('tiagofumo/vim-nerdtree-syntax-highlight')
call minpac#add('itchyny/lightline.vim')
call minpac#add('moll/vim-bbye')
call minpac#add('2072/PHP-Indenting-for-VIm')
call minpac#add('tanc/vdebug', {'branch': 'phpstorm-style'})
call minpac#add('posva/vim-vue')
call minpac#add('phpactor/phpactor',  {'do': '!composer install', 'for': 'php', 'type': 'opt'})
call minpac#add('lumiliet/vim-twig', {'for': 'twig'})
call minpac#add('w0rp/ale')
call minpac#add('maximbaz/lightline-ale')
call minpac#add('cj/vim-webdevicons')
call minpac#add('tomtom/tcomment_vim')
call minpac#add('hail2u/vim-css3-syntax', {'type': 'opt'})
call minpac#add('cakebaker/scss-syntax.vim', {'type': 'opt'})
call minpac#add('mileszs/ack.vim')

" Ultisnips
call minpac#add('SirVer/ultisnips')
call minpac#add('honza/vim-snippets')

" ncm2
call minpac#add('ncm2/ncm2')
call minpac#add('roxma/vim-hug-neovim-rpc')
call minpac#add('roxma/nvim-yarp')
call minpac#add('ncm2/ncm2-bufword')
call minpac#add('ncm2/ncm2-tmux')
call minpac#add('ncm2/ncm2-path')
call minpac#add('ncm2/ncm2-ultisnips')
call minpac#add('ncm2/ncm2-go', {'for': 'go', 'type': 'opt'})
call minpac#add('ncm2/ncm2-cssomni', {'type': 'opt'})
call minpac#add('phpactor/ncm2-phpactor', {'for': 'php', 'type': 'opt'})
call minpac#add('ncm2/ncm2-jedi', {'for': 'python', 'type': 'opt'})
call minpac#add('ncm2/ncm2-tern',  {'do': '!npm install', 'for': 'javascript', 'type': 'opt'})
call minpac#add('ncm2/nvim-typescript', {'do': '!./install.sh', 'for': 'typescript', 'type': 'opt'})

" ncm2
augroup NCM2
  au!
  autocmd BufEnter * call ncm2#enable_for_buffer()
  au User Ncm2PopupOpen set completeopt=noinsert,menuone
  au User Ncm2PopupClose set completeopt=menuone

  " CTRL-C doesn't trigger the InsertLeave autocmd. Map to <ESC> instead.
  inoremap <c-c> <ESC>

  " When the <Enter> key is pressed while the popup menu is visible
  " the menu and add a newline.
  inoremap <expr> <CR> (pumvisible() ? "\<c-e>\<cr>" : "\<CR>")

  " UltiSnips+NCM function parameter expansion

  " We don't really want UltiSnips to map these two, but there's no option for
  " that so just make it map them to a <Plug> key.
  let g:UltiSnipsExpandTrigger       = "<Plug>(ultisnips_expand_or_jump)"
  let g:UltiSnipsJumpForwardTrigger  = "<Plug>(ultisnips_expand_or_jump)"
  " Let UltiSnips bind the jump backward trigger as there's nothing special
  " about it.
  let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"

  " Try expanding snippet or jumping with UltiSnips.
  function! UltiSnipsExpandOrJumpOrTab()
    call UltiSnips#ExpandSnippetOrJump()
    return ""
  endfunction

  " First try expanding with ncm2_ultisnips. This does both LSP snippets and
  " normal snippets when there's a completion popup visible.
  inoremap <silent> <expr> <Tab> pumvisible() ? ncm2_ultisnips#expand_or("\<Plug>(ultisnips_try_expand)") : "<Tab>"

  " If that failed, try the UltiSnips expand or jump function. This handles
  " short snippets when the completion popup isn't visible yet as well as
  " jumping forward from the insert mode. Writes <Tab> if there is no special
  " action taken.
  inoremap <silent> <Plug>(ultisnips_try_expand) <C-R>=UltiSnipsExpandOrJumpOrTab()<CR>

  " Select mode mapping for jumping forward with <Tab>.
  snoremap <silent> <Tab> <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>

augroup END

augroup PackFTLoad
	autocmd!
	autocmd FileType php packadd phpactor
	autocmd FileType php packadd ncm2-phpactor
  autocmd FileType javascript,vue packadd ncm2-tern
  autocmd FileType typescript packadd nvim-typescript
  autocmd FileType python packadd ncm2-jedi
  autocmd FileType go packadd ncm2-go
  autocmd FileType css,scss,sass,vue packadd ncm2-cssomni
  " Ultisnips extras per filetype
  autocmd FileType css,scss,sass UltiSnipsAddFiletypes css
  autocmd FileType vue UltiSnipsAddFiletypes vue,js,css,scss
  autocmd FileType css,scss,sass,vue packadd vim-css3-syntax
  autocmd FileType css,scss,sass,vue packadd scss-syntax.vim
augroup END

"" phpactor mappings
" Include use statement
nmap <Leader>u :call phpactor#UseAdd()<CR>
" Invoke the context menu
nmap <Leader>mm :call phpactor#ContextMenu()<CR>
" Invoke the navigation menu
nmap <Leader>nn :call phpactor#Navigate()<CR>
" Goto definition of class or class member under the cursor
nmap <Leader>o <C-w>s :call phpactor#GotoDefinition()<CR>
" Transform the classes in the current file
nmap <Leader>tt :call phpactor#Transform()<CR>
" Generate a new class (replacing the current file)
nmap <Leader>cc :call phpactor#ClassNew()<CR>
" Extract expression (normal mode)
nmap <silent><Leader>ee :call phpactor#ExtractExpression(v:false)<CR>
" Extract expression from selection
vmap <silent><Leader>ee :<C-U>call phpactor#ExtractExpression(v:true)<CR>
" Extract method from selection
vmap <silent><Leader>em :<C-U>call phpactor#ExtractMethod()<CR>

" Add some useful commands for package management
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

" Mappings
nnoremap <C-p> :<C-u>FZF<CR>
nnoremap ” gT
nnoremap ’ gt

" Colourscheme
colorscheme vim-monokai-tasty

" tmux
call minpac#add('christoomey/vim-tmux-navigator')
call minpac#add('tmux-plugins/vim-tmux-focus-events')
call minpac#add('tmux-plugins/vim-tmux')

" NerdTree
call minpac#add('scrooloose/nerdtree')
let g:NERDTreeUpdateOnCursorHold = 0
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeWinSize = 40
let g:NERDTreeMinimalUI=1
let g:NERDTreeCascadeSingleChildDir=0
let g:NERDTreeAutoDeleteBuffer=1
nnoremap <leader>n :NERDTreeToggle<cr>
nnoremap <leader>N :NERDTreeFind<cr>

" Lightline config
set encoding=utf8
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ }

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }

let g:lightline.component_function = {
      \     'obsession': 'MyObsession',
      \     'filetype': 'MyFiletype',
      \     'fileformats': 'MyFileformat',
      \ }

let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf071"
let g:lightline#ale#indicator_errors = "\uf05e"
let g:lightline#ale#indicator_ok = "\uf00c"
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['php']= ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['html'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['scss'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['sass'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css'] = ''

let g:lightline.active = { 'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'filetype' ], [ 'obsession', 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! MyObsession()
  if exists("*ObsessionStatus")
    return ObsessionStatus('●', '○')
  endif
  return ''
endfunction

" Drupal Config
augroup module
  autocmd BufRead,BufNewFile *.module set filetype=php
  autocmd BufRead,BufNewFile *.install set filetype=php
  autocmd BufRead,BufNewFile *.test set filetype=php
  autocmd BufRead,BufNewFile *.inc set filetype=php
  autocmd BufRead,BufNewFile *.profile set filetype=php
  autocmd BufRead,BufNewFile *.view set filetype=php
augroup END

" Ale config
let g:ale_php_phpcs_standard = 'Drupal'
let g:ale_php_phpcbf_standard = 'Drupal'

" Tabs and indents
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent

" Remove the pipe character from splits
set fillchars+=vert:\

" Location of swap, backup, undo files
set undofile
set backupdir=.backup/,~/.config/nvim/.backup/,/tmp//
set directory=.swp/,~/.config/nvim/.swp/,/tmp//
set undodir=.undo/,~/.config/nvim/.undo/,/tmp//

" open devdocs.io with firefox and search the word under the cursor
command! -nargs=? DevDocs :call system('type -p open >/dev/null 2>&1 && open https://devdocs.io/#q=<args> || firefox -url https://devdocs.io/#q=<args>')
autocmd vimrc FileType php,javascript,html,coffee nmap <buffer> <leader>D :exec "DevDocs " . fnameescape(expand('<cword>'))<CR>

" restore the position of the last cursor when you open a file
autocmd vimrc BufReadPost * call general#RestorePosition()

" delete trailing space when saving files
autocmd vimrc BufWrite *.php,*.js,*.jsx,*.vue,*.twig,*.html,*.sh,*.yaml,*.yml :call general#DeleteTrailingWS()

" Window
nmap <leader>sw<left>  :topleft  vnew<CR>
nmap <leader>sw<right> :botright vnew<CR>
nmap <leader>sw<up>    :topleft  new<CR>
nmap <leader>sw<down>  :botright new<CR>
" Buffer
nmap <leader>s<left>   :leftabove  vnew<CR>
nmap <leader>s<right>  :rightbelow vnew<CR>
nmap <leader>s<up>     :leftabove  new<CR>
nmap <leader>s<down>   :rightbelow new<CR>

" set line number
set number

" the copy goes to the clipboard
set clipboard+=unnamedplus

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" vdebug options
if !exists('g:vdebug_options')
  let g:vdebug_options = {}
endif
let g:vdebug_options.break_on_open = 0
let g:vdebug_options.window_commands = {
      \   'DebuggerWatch': 'below new',
      \   'DebuggerStack': 'belowright new',
      \   'DebuggerStatus': 'vertical leftabove new'
      \ }

let g:vdebug_options.window_arrangement = ["DebuggerWatch", "DebuggerStatus", "DebuggerStack"]

" VIM colours
" let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
" set termguicolors
highlight LineNr ctermfg=233

augroup vimrc
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
  let g:better_whitespace_enabled=1
  let g:strip_whitespace_on_save=1
  let g:strip_whitespace_confirm=0
  if executable('ag')
    let g:ackprg = 'ag --vimgrep'
  endif
augroup END

set exrc
set secure
