if type -q kubecolor
    kubecolor $argv
else
    kubectl $argv
end
