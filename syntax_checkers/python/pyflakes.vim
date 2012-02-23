"============================================================================
"File:        pyflakes.vim
"Description: Syntax checking plugin for syntastic.vim
"Authors:     Martin Grenfell <martin.grenfell@gmail.com>
"             kstep <me@kstep.me>
"             Parantapa Bhattacharya <parantapa@gmail.com>
"
"============================================================================
function! SyntaxCheckers_python_Term(i)
    if a:i['type'] ==# 'E'
        let a:i['text'] = "Syntax error"
    endif
    if match(a:i['text'], 'is assigned to but never used') > -1
                \ || match(a:i['text'], 'imported but unused') > -1
                \ || match(a:i['text'], 'undefined name') > -1
                \ || match(a:i['text'], 'redefinition of') > -1
                \ || match(a:i['text'], 'referenced before assignment') > -1
                \ || match(a:i['text'], 'duplicate argument') > -1
                \ || match(a:i['text'], 'after other statements') > -1
                \ || match(a:i['text'], 'shadowed by loop variable') > -1

        let term = split(a:i['text'], "'", 1)[1]
        return '\V\<'.term.'\>'
    endif
    return ''
endfunction

function! SyntaxCheckers_python_GetLocList()
    let makeprg = 'pyflakes '.g:syntastic_python_checker_args.' '.shellescape(expand('%'))
    let errorformat = '%E%f:%l: could not compile,%-Z%p^,%W%f:%l:%c: %m,%W%f:%l: %m,%-G%.%#'

    let errors = SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })

    call SyntasticHighlightErrors(errors, function('SyntaxCheckers_python_Term'))

    return errors
endfunction
