starship init fish | source

if test -z $DISPLAY; and test (tty) = "/dev/tty1"
    sway
end
