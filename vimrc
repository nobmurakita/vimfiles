set encoding=utf-8
scriptencoding utf-8

" Note: Skip initialization for vim-tiny or vim-small
if !1 | finish | endif

if has('win32') || has('win64')
  let $VIMFILES=expand('~/vimfiles')
else
  let $VIMFILES=expand('~/.vim')
endif


augroup MyAutoCmd
  autocmd!
augroup END

syntax on

let mapleader = ";"
source $VIMRUNTIME/macros/matchit.vim

" マッピングとキーコードにタイムアウトを設定
" ESCの反応が鈍い ＆ 挿入モードのカーソルキーで A B C D が入力される問題の対処
set timeout timeoutlen=1000 ttimeoutlen=50

" 外部で変更のあったファイルを自動的に読みなおす
set autoread
autocmd MyAutoCmd BufEnter,WinEnter * checktime

" 起動時のスプラッシュを表示しない
set shortmess+=I

" バックアップファイル、スワップファイルを作らない
set nobackup
set noswapfile
set viminfo+=n$VIMFILES/tmp/viminfo

" undo永続化
if has('persistent_undo')
  set undofile
  set undodir=$VIMFILES/tmp/undo
  if !isdirectory(expand($VIMFILES.'/tmp/undo'))
    call mkdir(expand($VIMFILES.'/tmp/undo'))
  endif
endif

" 表示関係
set number
set scrolloff=5
set sidescroll=2
set sidescrolloff=10
set display=lastline
set lazyredraw

" 折り返し
if exists('+breakindent')
  set breakindent
  set showbreak=....
endif
set nowrap
nnoremap <Leader>w :<C-u>setlocal wrap! wrap?<CR>

" フリーカーソル(挿入モードは無効)
set virtualedit=all
autocmd MyAutoCmd InsertEnter * setlocal virtualedit=
autocmd MyAutoCmd InsertLeave * setlocal virtualedit=all

" 未保存のバッファの設定
set hidden
set confirm

" タブの設定
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround

" インデントの設定
set autoindent
set smartindent
set nocindent

" 検索の設定
set hlsearch
set incsearch
set ignorecase
set smartcase

" 不可視文字の表示
set list
set listchars=tab:+-,extends:^,precedes:^

" バックスペースの設定
set backspace=start,eol,indent

" ウィンドウ
set noequalalways
set winheight=3

" マウス
set mouse=a

" クリップボードの設定
set clipboard+=unnamed

" ビープ音の抑制
set noerrorbells
set visualbell t_vb=

" 古い正規表現を使う
set regexpengine=1

" IMEの設定
set iminsert=0
set imsearch=0

" コマンドラインの設定
set noshowmode
set showcmd

" ステータスラインの設定
set laststatus=2
set statusline=%{&ft=='help'?'HELP':get(g:mode_map,mode(),'?')}\ %{&readonly?'RO':&modified?'+':'-'}
set statusline+=\ %t\ \(%<%{expand('%:h')!=''?expand('%:h'):'.'}\)
set statusline+=\ %=%y[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3p%%][%3LL]
let g:mode_map = {
\   'n' : 'NORMAL',
\   'i' : 'INSERT',
\   'R' : 'REPLACE',
\   'v' : 'VISUAL',
\   'V' : 'V-LINE',
\   'c' : 'COMMAND',
\   "\<C-v>": 'V-BLOCK',
\   's' : 'SELECT',
\   'S' : 'S-LINE',
\   "\<C-s>": 'S-BLOCK',
\ }

" ファイルフォーマットの設定
set fileformat=unix
set fileformats=unix,dos,mac

" エンコーディングの設定
set fileencodings=utf-8,ucs-bom,iso-2022-jp,euc-jp,cp932

" 全角文字の表示幅
if has('kaoriya')
  set ambiwidth=auto
else
  set ambiwidth=double
endif

" テキストの幅
set textwidth=120
set formatexpr=0
if exists('&colorcolumn')
  set colorcolumn=+1
endif

" 補完
set completeopt=menuone
set pumheight=20
autocmd MyAutoCmd FileType *
\ if &omnifunc == "" |
\   setlocal omnifunc=syntaxcomplete#Complete |
\ endif

" JISに誤認したASCIIファイルのエンコーディングを修正する
autocmd MyAutoCmd BufReadPost *
\ if &l:fileencoding ==# 'iso-2022-jp' && search('[^\x01-\x7e]', 'n') == 0 |
\   let &l:fileencoding = &encoding |
\ endif

" バッファを閉じる
nnoremap <silent> <Leader><Leader>d :<C-u>bdelete<CR>
nnoremap <silent> <Leader><Leader>D :<C-u>bdelete!<CR>

" カーソル移動
nnoremap j gj
nnoremap k gk

" yank,paste後のカーソル位置
vnoremap <silent> y ygv<ESC>
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" <NL>入力を禁止
inoremap <NL> <Nop>

" QuickFix
command! QfClear call setqflist([]) | doautocmd QuickFixCmdPost
command! LocClear call setloclist(0, []) | doautocmd QuickFixCmdPost

" タグファイルの設定
if has('path_extra')
  set tags+=tags;
endif

" カーソル位置を復元
autocmd MyAutoCmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif

" ファイルタイプ別のタブ設定
autocmd MyAutoCmd FileType ruby,eruby setlocal softtabstop=2 shiftwidth=2
autocmd MyAutoCmd FileType vim setlocal softtabstop=2 shiftwidth=2

" Vim script の継続行のインデントを無効にする
let g:vim_indent_cont = 0

" markdown内のプログラミング言語をハイライト
let g:markdown_fenced_languages = [
\   'ruby',
\   'python',
\   'php',
\   'javascript',
\   'js=javascript',
\   'json=javascript',
\   'html',
\   'css',
\ ]

" plugins
source $VIMFILES/plugin.vim
