if type -q ssh.exe
    ssh.exe $argv
else
    ssh $argv
end
