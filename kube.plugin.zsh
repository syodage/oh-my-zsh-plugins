# Kube plugin

kubectl_completion() {
    (( prev = $CURRENT - 1 ))
    prevWord=${words[prev]}
    nsIndex=${words[(ie)-n]} # (ie) - exact match in the array
     
    if [[ $nsIndex -le ${#words} ]]; then
        # Assumption: if -n is used then the next index has the namespace
       namespace=${words[nsIndex + 1]}
    fi
    # echo "current:${CURRENT}, prev:${prev}"
    # echo "prevWord:${prevWord}"
    if [[ $CURRENT = 2 ]]; then 
        reply=(-n get pods)
    elif [[ $prevWord = '-n' ]]; then
         reply=($(kubectl get namespaces |  awk 'BEGIN{ORS=" ";} NR>1 {print $1}' ))
    elif [[ $prevWord = 'get' ]]; then
        reply=(pods services namespaces deployment)
    elif [[ $prevWord = 'logs' ]]; then
        reply=($(kubectl -n ${namespace:-default} get pods 2>/dev/null | awk 'BEGIN{ORS=" ";} NR>1 {print $1}' ))
    else
         reply=()
    fi
}

compctl -K kubectl_completion kubectl