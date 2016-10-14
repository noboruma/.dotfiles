let g:airline#themes#custom#palette = {}

let s:guibg = '#a8a8a8'
let s:guibg2 = '#b8b8b8'
let s:ftfg = '#1111ff'
let s:normalfg = '#080808'
let s:inactivefg = '#080808'
let s:inactivebg = '#a8a8a8'
let s:termbg = 232
let s:termbg2= 234

let s:N1 = [ s:normalfg , '#b8b8b8' , s:termbg , 45 ]
let s:N2 = [ s:ftfg , s:guibg2, 202 , s:termbg2 ]
let s:N3 = [ s:normalfg , s:guibg, 243 , s:termbg]
let g:airline#themes#custom#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#custom#palette.normal_modified = {
      \ 'airline_c': [ '#df0000' , s:guibg, 160     , s:termbg    , ''     ] ,
      \ }


let s:I1 = [ s:guibg, '#df0000' , s:termbg , 82 ]
let s:I2 = [ s:ftfg , s:guibg2, 202 , s:termbg2 ]
let s:I3 = [ s:normalfg , s:guibg, 243 , s:termbg ]
let g:airline#themes#custom#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#custom#palette.insert_modified = copy(g:airline#themes#custom#palette.normal_modified)
let g:airline#themes#custom#palette.insert_paste = {
      \ 'airline_a': [ s:I1[0]   , '#d78700' , s:I1[2] , 172     , ''     ] ,
      \ }


let g:airline#themes#custom#palette.replace = {
      \ 'airline_a': [ s:I1[0]   , '#af0000' , s:I1[2] , 124     , ''     ] ,
      \ }
let g:airline#themes#custom#palette.replace_modified = copy(g:airline#themes#custom#palette.normal_modified)


let s:V1 = [ s:guibg, '#508830' , s:termbg , 184 ]
let s:V2 = [ s:ftfg , s:guibg2, 202 , s:termbg2 ]
let s:V3 = [ s:normalfg , s:guibg, 243 , s:termbg ]
let g:airline#themes#custom#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#custom#palette.visual_modified = copy(g:airline#themes#custom#palette.normal_modified)


let s:IA2 = [ s:inactivefg , s:inactivebg , 239 , s:termbg2 , '' ]
let g:airline#themes#custom#palette.inactive = airline#themes#generate_color_map(s:IA2, s:IA2, s:IA2)
let g:airline#themes#custom#palette.inactive_modified = {
      \ 'airline_c': [ '#df0000', '', 160, '', '' ] ,
      \ }

