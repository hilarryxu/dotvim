call xcc#clz#helper#load()
call xcc#clz#treemenu#load()

fun! SetOption(frombuf,cmd)
  let a = bufnr('%')
  exec winbufnr(a:frombuf) . 'wincmd w'
  exec a:cmd
  exec winbufnr(a) . 'wincmd w'
endf

fun! s:OptionMenuBufferToggle()
  let frombuf = bufnr('%')

  30vnew
  setlocal buftype=nofile noswapfile bufhidden=wipe
  setlocal nobuflisted nowrap cursorline nonumber fdc=0

  cal g:Help.reg('Option Menu',join([
        \' <Enter> - execute item',
        \],"\n"),0)

  let m = g:MenuBuffer.create({ 'rootLabel': 'Option' , 'buf_nr': bufnr('%') })
  cal m.createChild({ 
      \'label': 'Line Number' ,
      \'close':0,
      \'exe': function('SetOption') , 'args': [ frombuf , 'set nu!'] })

  cal m.createChild({ 
      \'label': 'Toggle Folding' ,
      \'close':0,
      \'exe': function('SetOption') , 'args': [ frombuf , 'set foldenable!'] })

  cal m.createChild({ 
      \'label': 'Toggle ExpandTab' ,
      \'close':0,
      \'exe': function('SetOption') , 'args': [ frombuf , 'set et!'] })


  cal m.createChild({ 
      \'label': 'Toggle ListChar' ,
      \'close':0,
      \'exe': function('SetOption') , 'args': [ frombuf , 'set list!'] })

  cal m.createChild({ 
      \'label': 'Make vimrc' ,
      \'close':0,
      \'exe': function('SetOption') , 'args': [ frombuf , 'mkvimrc'] })

  cal m.createChild({ 
      \'label': 'Syntax On' ,
      \'close':0,
      \'exe': function('SetOption') , 'args': [ frombuf , 'syntax on'] })

  cal m.createChild({ 
      \'label': 'Syntax Off' ,
      \'close':0,
      \'exe': function('SetOption') , 'args': [ frombuf , 'syntax off'] })


  cal m.render()
endf

com! OptionMenu  :cal s:OptionMenuBufferToggle()

nmap <Leader>om :OptionMenu<CR>
