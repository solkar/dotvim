" detect OS {{{
  let s:is_windows = has('win32') || has('win64')
  let s:is_cygwin = has('win32unix')
  let s:is_macvim = has('gui_macvim')
"}}}

" dotvim settings {{{
let g:dotvim_settings = {}
let g:dotvim_settings.version = 1
let s:cache_dir = get(g:dotvim_settings, 'cache_dir', '~/.vim/.cache')
"}}}

" initialize default settings
let s:settings = {}
let s:settings.default_indent = 2
let s:settings.max_column = 120
let s:settings.autocomplete_method = 'neocomplcache'
let s:settings.enable_cursorcolumn = 0
"let s:settings.colorscheme = 'jellybeans'
let s:settings.colorscheme = 'badwolf'

" functions {{{
  function! s:get_cache_dir(suffix) "{{{
    return resolve(expand(s:cache_dir . '/' . a:suffix))
  endfunction "}}}
"}}}

set nocompatible	" use vim defaults
filetype off

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'


"plugin/mapping configuration {{{
NeoBundle 'scrooloose/syntastic' "{{{
      let g:syntastic_error_symbol = '✗'
      let g:syntastic_style_error_symbol = '✠'
      let g:syntastic_warning_symbol = '∆'
      let g:syntastic_style_warning_symbol = '≈'
    "}}}
NeoBundle 'Lokaltog/powerline'
let g:Powerline_symbols = 'fancy'
set guifont=Menlo\ Regular\ for\ Powerline:h12d
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
NeoBundle 'kien/rainbow_parentheses.vim'

"NeoBundle 'Shougo/vimproc.vim', {
"\ 'build' : {
"\     'windows' : 'tools\\update-dll-mingw',
"\     'cygwin' : 'make -f make_cygwin.mak',
"\     'mac' : 'make -f make_mac.mak',
"\     'linux' : 'make',
"\     'unix' : 'gmake',
"\    },
"\ }
" Completion
NeoBundle 'Shougo/neocomplete' , {'autoload':{'insert':1}, 'vim_version':'7.3.885'} "{{{
        let g:acp_enableAtStartup = 0 " Disable AutoComplPop.
        let g:neocomplete#enable_at_startup = 1
        let g:neocomplete#enable_smart_case = 1
        let g:neocomplete#sources#syntax#min_keyword_length = 3
        let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
        let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
                \ }
        
        if !exists('g:neocomplete#keyword_patterns')
            let g:neocomplete#keyword_patterns = {}
        endif
        let g:neocomplete#keyword_patterns['default'] = '\h\w*'

        inoremap <expr><C-g>     neocomplete#undo_completion()
        inoremap <expr><C-l>     neocomplete#complete_common_string()
        inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
        function! s:my_cr_function()
            return neocomplete#close_popup() . "\<CR>"
            " For no inserting <CR> key.
            "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
        endfunction

        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
                    \ <SID>check_back_space() ? "\<TAB>" :
                    \ neocomplete#start_manual_complete()
        function! s:check_back_space() "{{{
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~ '\s'
        endfunction "}}}
        " <C-h>, <BS>: close popup and delete backword char.
        inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr><C-y>  neocomplete#close_popup()
        inoremap <expr><C-e>  neocomplete#cancel_popup()
        if !exists('g:neocomplete#sources#omni#input_patterns')
            let g:neocomplete#sources#omni#input_patterns = {}
        endif


        " For perlomni.vim setting.
        " https://github.com/c9s/perlomni.vim
        let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
        let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'
"}}}
NeoBundle 'honza/vim-snippets'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neosnippet.vim' "{{{
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'
    let g:neosnippet#enable_snipmate_compatibility=1
    
    imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : "\<TAB>")
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
    smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""

    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)
"}}}
NeoBundle 'avakhov/vim-yaml'
NeoBundle 'vim-scripts/loremipsum'
NeoBundle 'Chiel92/vim-autoformat'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'OmniSharp/omnisharp-vim' "{{{
let g:OmniSharp_selector_ui = 'unite'  " Use unite.vim
"let g:OmniSharp_selector_ui = 'ctrlp'  " Use ctrlp.vim
"}}}
NeoBundle 'OrangeT/vim-csharp'

" unite & extensions{{{ 
NeoBundle 'Shougo/unite.vim' "{{{
      let bundle = neobundle#get('unite.vim')
      function! bundle.hooks.on_source(bundle)
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        call unite#filters#sorter_default#use(['sorter_rank'])
        call unite#custom#profile('default', 'context', {
              \ 'start_insert': 1
              \ })
      endfunction

      let g:unite_data_directory=s:get_cache_dir('unite')
      let g:unite_source_history_yank_enable=1
      let g:unite_source_rec_max_cache_files=5000

      if executable('ag')
        let g:unite_source_grep_command='ag'
        let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
        let g:unite_source_grep_recursive_opt=''
      elseif executable('ack')
        let g:unite_source_grep_command='ack'
        let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
        let g:unite_source_grep_recursive_opt=''
      endif

      function! s:unite_settings()
        nmap <buffer> Q <plug>(unite_exit)
        nmap <buffer> <esc> <plug>(unite_exit)
        imap <buffer> <esc> <plug>(unite_exit)
      endfunction
      autocmd FileType unite call s:unite_settings()

      nmap <space> [unite]
      nnoremap [unite] <nop>

      if s:is_windows
        nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec:! buffer file_mru bookmark<cr><c-u>
        nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec:!<cr><c-u>
      else
        nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec/async:! buffer file_mru bookmark<cr><c-u>
        nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async:!<cr><c-u>
      endif
      nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=recent file_mru<cr>
      nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
      nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
      nnoremap <silent> [unite]b :<C-u>Unite -auto-resize -buffer-name=buffers buffer file_mru<cr>
      nnoremap <silent> [unite]- :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
      nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
      nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>
    "}}}
    NeoBundleLazy 'Shougo/neomru.vim', {'autoload':{'unite_sources':'file_mru'}}
    NeoBundleLazy 'osyo-manga/unite-airline_themes', {'autoload':{'unite_sources':'airline_themes'}} "{{{
      nnoremap <silent> [unite]a :<C-u>Unite -winheight=10 -auto-preview -buffer-name=airline_themes airline_themes<cr>
    "}}}
    NeoBundleLazy 'ujihisa/unite-colorscheme', {'autoload':{'unite_sources':'colorscheme'}} "{{{
      nnoremap <silent> [unite]c :<C-u>Unite -winheight=10 -auto-preview -buffer-name=colorschemes colorscheme<cr>
    "}}}
    NeoBundleLazy 'tsukkee/unite-tag', {'autoload':{'unite_sources':['tag','tag/file']}} "{{{
      nnoremap <silent> [unite]t :<C-u>Unite -auto-resize -buffer-name=tag tag tag/file<cr>
    "}}}
    NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}} "{{{
      nnoremap <silent> [unite]o :<C-u>Unite -auto-resize -buffer-name=outline outline<cr>
    "}}}
    NeoBundleLazy 'Shougo/unite-help', {'autoload':{'unite_sources':'help'}} "{{{
      nnoremap <silent> [unite]h :<C-u>Unite -auto-resize -buffer-name=help help<cr>
    "}}}
    NeoBundleLazy 'Shougo/junkfile.vim', {'autoload':{'commands':'JunkfileOpen','unite_sources':['junkfile','junkfile/new']}} "{{{
      let g:junkfile#directory=s:get_cache_dir('junk')
      nnoremap <silent> [unite]j :<C-u>Unite -auto-resize -buffer-name=junk junkfile junkfile/new<cr>
    "}}}
"}}}
NeoBundle "mileszs/ack.vim"
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-git'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-repeat'
NeoBundleLazy 'tpope/vim-markdown', {'autoload':{'filetypes':['markdown']}}
NeoBundleLazy 'scrooloose/nerdtree', {'autoload':{'commands':['NERDTreeToggle','NERDTreeFind']}} "{{{
  let NERDTreeShowHidden=1
  let NERDTreeQuitOnOpen=0
  let NERDTreeShowLineNumbers=1
  let NERDTreeChDirMode=0
  let NERDTreeShowBookmarks=1
  let NERDTreeIgnore=['\.git','\.hg']
  let NERDTreeBookmarksFile=s:get_cache_dir('NERDTreeBookmarks')
  nnoremap <F2> :NERDTreeToggle<CR>
  nnoremap <F3> :NERDTreeFind<CR>
"}}}
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'ctrlpvim/ctrlp.vim', { 'depends': 'tacahiroy/ctrlp-funky' } "{{{
      let g:ctrlp_clear_cache_on_exit=1
      let g:ctrlp_max_height=40
      let g:ctrlp_show_hidden=0
      let g:ctrlp_follow_symlinks=1
      let g:ctrlp_max_files=20000
      let g:ctrlp_cache_dir=s:get_cache_dir('ctrlp')
      let g:ctrlp_reuse_window='startify'
      let g:ctrlp_extensions=['funky']
      let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/]\.(git|hg|svn|idea)$',
            \ 'file': '\v\.DS_Store$'
            \ }

      if executable('ag')
        let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
      endif

      nmap º [ctrlp]
      nnoremap [ctrlp] <nop>

      nnoremap [ctrlp]t :CtrlPBufTag<cr>
      nnoremap [ctrlp]T :CtrlPTag<cr>
      nnoremap [ctrlp]l :CtrlPLine<cr>
      nnoremap [ctrlp]o :CtrlPFunky<cr>
      nnoremap [ctrlp]b :CtrlPBuffer<cr>
"}}}

let g:CommandTMatchWindowAtTop=1 " show window at top

NeoBundleLazy 'majutsushi/tagbar', {'autoload':{'commands':'TagbarToggle'}} "{{{
      nnoremap <silent> <F4> :TagbarToggle<CR>
"}}}

NeoBundle 'tommcdo/vim-exchange'
NeoBundle 'mtth/scratch.vim'
NeoBundle 'elzr/vim-json'
NeoBundle 'junegunn/goyo.vim'
NeoBundle 'jtratner/vim-flavored-markdown.git'
NeoBundle 'junegunn/vim-easy-align'
NeoBundleLazy 'godlygeek/tabular', {'autoload':{'commands':'Tabularize'}} "{{{
      nmap <Leader>a& :Tabularize /&<CR>
      vmap <Leader>a= :Tabularize /=<CR>
      vmap <Leader>a: :Tabularize /:<CR>
      vmap <Leader>a:: :Tabularize /:\zs<CR>
      vmap <Leader>a, :Tabularize /,<CR>
      vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    "}}}
"}}}



" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


set completeopt+=preview

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete


" base configuration{{{
set number		        " show line numbers
set hlsearch            " highlight searches
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set ttyfast
set noswapfile
set nobackup
set nowritebackup
set enc=utf-8
set fencs=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ruler
set backspace=indent,eol,start
set laststatus=2
"set relativenumber
set undofile
set autoread                "auto reload if file saved externally
if exists('$TMUX')
    set clipboard=
else
    set clipboard=unnamed   "sync with OS clipboard
endif


let mapleader = ","
"}}}

" Search options{{{
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
"}}}


let g:pydiction_location = '~/.vim/ftplugin/pydiction-1.2/complete-dict'

" Omnicompletion functions
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
call pathogen#infect()

" Shortcut to rapidly toggle `set list`
nmap <Leader>l :set list!<CR>
  
"  Use the same symbols as TextMate for tabstops and EOLs set list
set listchars=tab:▸\ ,eol:¬

" remap arrow keys
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>
nnoremap <up> :tabnext<CR>
nnoremap <down> :tabprev<CR>

nnoremap j gj
nnoremap k gk

" next and repeat
nnoremap Q :normal n.<CR>

" format JSON
nmap <Leader>j !python -m json.tool<CR>


" color schemes {{{
  NeoBundle 'altercation/vim-colors-solarized' "{{{
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
  "}}}
  NeoBundle 'nanotech/jellybeans.vim'
  NeoBundle 'tomasr/molokai'
  NeoBundle 'chriskempson/vim-tomorrow-theme'
  NeoBundle 'chriskempson/base16-vim'
  NeoBundle 'w0ng/vim-hybrid'
  NeoBundle 'sjl/badwolf'
  NeoBundle 'gilgigilgil/anderson.vim' 
  NeoBundle 'Lokaltog/vim-distinguished'
  NeoBundle 'zeis/vim-kolor' 
  "{{{
    let g:kolor_underlined=1
  "}}}
"}}}



"Remove search highlights
nnoremap <leader><space> :noh<cr>

" remap tab key to match bracket pairs
nnoremap <tab> %
vnoremap <tab> %

" Wrap long lines
set wrap
set textwidth=90
set formatoptions=qrn1
set colorcolumn=120

au FocusLost * :wa	" save the file when focus changes to another tab, window, whatever
nnoremap <leader>w <C-w>v<C-w>l " Open vertical window and focus

nnoremap <leader>a :Ack<space>
nnoremap <leader>v :tabe $MYVIMRC<cr>

" Automatically source vimrc on save.
autocmd! bufwritepost .vimrc source $MYVIMRC

":nmap <Leader>s :Scratch<cr>
" Open my personal snippets file
"nnoremap <leader>q :tabe ~/.vim/bundle/ultisnips-snippets/my_snippets/objc.snippets<cr>
nnoremap <leader>q :tabe ~/.vim/bundle/vim-snippets/snippets/cs.snippets<cr>

au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


" resize current buffer by +/- 5 
nnoremap <D-left> :vertical resize -5<cr>
nnoremap <D-down> :resize +5<cr>
nnoremap <D-up> :resize -5<cr>
nnoremap <D-right> :vertical resize +5<cr>

" Build project
nnoremap <leader>m :make<cr>

" open tag in new window
map <C-\> :tab split<CR>:exec("ts ".expand("<cword>"))<CR>

" ctags
" function to loop through a specified path and include each tag file
if has('python')
function! BuildTagsFromPath()
python << EOF
import os

tags = ''
tagpath = "%s/%s" % (os.environ['HOME'], '.vimtags')

if (os.path.exists(tagpath)):
    for file in os.listdir(tagpath):
        if (file != 'README'):
            tags += "%s/%s," % (tagpath, file)


cmdsettags = "set tags=%s" % tags
vim.command(cmdsettags)
EOF
endfunction

call BuildTagsFromPath()
endif

" Spanish keyboard mappings
noremap <C-+> <C-]> 
noremap <A-+> <A-]>
noremap <C-º> <C-\> 

" ctags force multiple match list
noremap  <C-]>  g<C-]>
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
map <leader>h :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" a.vim options
let g:alternateExtensions_m = "h"
let g:alternateExtensions_h = "cpp"
let g:alternateExtensions_cpp = "h"
let g:alternateExtensions_hpp = "cpp"
map <leader>ss :A<cr>

"auto wrapping for gitcommit messages
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd Filetype txt setlocal spell textwidth=72
autocmd Filetype md setlocal spell textwidth=72
au BufRead,BufNewFile *.md setlocal spell textwidth=72

" Close other panes
nnoremap <leader>o :on<cr>

" Text substitution - Typos
iab widht           width
iab wudht           width
iab sefl            self
iab lenght          length
iab teh             the
iab visibel         visible
iab postion         position
iab positino        position
iab funtion         function
iab rigth           right
iab verison         version
iab virutal         virtual
iab acotr           actor
iab srting          string
iab spirte          sprite
iab nieghborhood    neighborhood
iab locatios        locations
iab dió             dio
iab actios          actions
iab asi             así
iab virtual         virtual


call neobundle#end()
filetype plugin indent on
syntax enable
exec 'colorscheme '.s:settings.colorscheme

NeoBundleCheck
