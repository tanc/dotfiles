" Declare the general config group for autocommand
augroup vimrc
  autocmd!
augroup END

let mapleader = "\<Space>"

" Set up minpac
packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('tpope/vim-unimpaired')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('tpope/vim-obsession')
call minpac#add('tiagofumo/vim-nerdtree-syntax-highlight')
call minpac#add('itchyny/lightline.vim')
call minpac#add('moll/vim-bbye')
call minpac#add('2072/PHP-Indenting-for-VIm')
call minpac#add('vim-vdebug/vdebug')
call minpac#add('posva/vim-vue')
call minpac#add('phpactor/phpactor',  {'do': '!composer install', 'for': 'php', 'type': 'opt'})

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
call minpac#add('ncm2/ncm2-cssomni', {'for': 'css', 'type': 'opt'})
call minpac#add('phpactor/ncm2-phpactor', {'for': 'php', 'type': 'opt'})
call minpac#add('ncm2/ncm2-jedi', {'for': 'python', 'type': 'opt'})
call minpac#add('ncm2/ncm2-tern',  {'do': '!npm install', 'for': 'javascript', 'type': 'opt'})
call minpac#add('ncm2/nvim-typescript', {'do': '!./install.sh', 'for': 'typescript', 'type': 'opt'})

augroup NCM2
  au!
  autocmd BufEnter * call ncm2#enable_for_buffer()
  au User Ncm2PopupOpen set completeopt=noinsert,menuone,preview
  au User Ncm2PopupClose set completeopt=menuone
  " Use <TAB> to select the popup menu:
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
augroup END

augroup PackFTLoad
	autocmd!
	autocmd FileType php packadd phpactor
	autocmd FileType php packadd ncm2-phpactor
  autocmd FileType javascript packadd ncm2-tern
  autocmd FileType typescript packadd nvim-typescript
  autocmd FileType python packadd ncm2-jedi
  autocmd FileType go packadd ncm2-go
  autocmd FileType css packadd ncm2-cssomni
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
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

" Mappings
nnoremap <C-p> :<C-u>FZF<CR>
nnoremap ” gT
nnoremap ’ gt

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

" VIM colours
highlight LineNr ctermfg=233
