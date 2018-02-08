eval (python -m virtualfish auto_activation global_requirements compat_aliases)
set -gx PATH /usr/local/bin $PATH

functions -c fish_prompt _old_fish_prompt
function fish_prompt
    _old_fish_prompt
    if set -q VIRTUAL_ENV
        echo -n -s "[" (set_color cyan) (basename "$VIRTUAL_ENV") (set_color normal) "]" " "
    end
end
