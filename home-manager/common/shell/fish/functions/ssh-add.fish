if type -q ssh-add.exe
    ssh-add.exe $argv
else
    ssh-add $argv
end
