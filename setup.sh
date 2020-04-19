#!/bin/bash
SWITCH_CONTEXT="switch-context-kc"
LIST_CONTEXT="list-context-kc"
CURRENT_CONTEXT="current-context-kc"
LIST_PODS="list-pods-kc"
LOGS="logs-kc"
TAIL="tail"
FOLLOW="follow"
EXECUTE="execute-kc"
EXECUTE_ALL="execute-all-kc"
KUBECALL_SCRIPT_PATH="/usr/local/bin"
KUBECALL_AUTO_COMPLETE_FILE_NAME="kubecall_auto_complete"
LINE_SEPERATOR="\n---------------------------------------------------------------------------------------------------"

function kubecall_setup_help() {
    cat << EndOfMessage
 kubecall is bash wrapper around kubectl for effortless interaction with kubernetes.

 Setup:

 add             : creates and adds kubecall to user's bashrc
 remove          : removes kubecall from bashrc

 Note: for kubecall to work, a working kubectl setup is needed, kubecall is by no means a replacement
      for kubectl, it is just a wrapper around kubectl with some additional options.
EndOfMessage
}

function create_update_kubecall_auto_complete_file() {
    contexts=$(kubectl config get-contexts -o=name | tr "\n" " ")
    context_values=($contexts)
    context_keys=("${!context_values[@]}")

    echo -e $LINE_SEPERATOR
    kubectl config get-contexts -o=name | grep -n '^'
    echo -e $LINE_SEPERATOR

    echo -e "Preparing autocompletion for contexts and it's deployments"
    echo "skip contexts from autocompletion by entering comma seperated numbers or ranged numbers"
    echo "eg. 1-4,7-9,12,14 or presse enter to continue with all contexts"

    echo -e $LINE_SEPERATOR
    IFS=', ' read -r -a tbs

    if [[ ${#tbs[@]} > 0 ]]; then
        echo -e $LINE_SEPERATOR
    fi

    for i in ${tbs[@]}
        do
            if [[ $i -le 0 ]]; then
                IFS='-' read -r -a i <<< $i; ioffset=$((${i[0]}-1)); ilimit=$((${i[1]}-${i[0]}+1));
                echo "Skipping"
                for j in "${context_keys[@]:ioffset:ilimit}"; do
                    echo -e "\t $(($j+1)). ${context_values[$j]}"
                    unset "context_values[$j]"
                done
            else
                clustor_no=$((i-1))
                echo "Skipping $i. ${context_values[$clustor_no]}"
                unset context_values[$clustor_no]
            fi
        done

    if [[ ${#tbs[@]} > 0 ]]; then
        echo -e $LINE_SEPERATOR
    fi

    deployments_map=()
    context_values=( "${context_values[@]}" )
    if [[ ${#context_values[@]} > 0 ]]; then
        echo "Depending upon connection speed and number of deployments, it might take anywhere between 20sec to 1min. for each context to to be cached."
        echo -e $LINE_SEPERATOR
        for i in "${context_values[@]}"
            do
                echo -n "Creating autocompletion for deployments under: $i ..."
                result=$(kubectl get deployments -o=name | sort -n | tr "\n" " ")
                formatted_result=("${result//deployment.extensions\//}")
                deployments_map+=("if [[ \${#COMP_WORDS[@]} == \"4\" ]] && [[ \${COMP_WORDS[2]} == \"$i\" ]]; then COMPREPLY=(\$(compgen -W \"$formatted_result\" \"\${COMP_WORDS[3]}\")); return; fi; ")
                echo "Done"
            done
        echo -e $LINE_SEPERATOR
        echo "Autocompletion data calculated for selected contexts"
        echo -e $LINE_SEPERATOR
    fi

    kubecall_cmds_string="$SWITCH_CONTEXT $LIST_CONTEXT $CURRENT_CONTEXT $LIST_PODS $LOGS $EXECUTE $EXECUTE_ALL"
    echo -n "Writing kubecall to system..."
    kubecall_autocomplete_fun_def="_kubecall_completions() { ${deployments_map[@]} if [[ \"\${#COMP_WORDS[@]}\" == \"3\" ]]; then COMPREPLY=(\$(compgen -W \"$contexts\" \"\${COMP_WORDS[2]}\")); return; fi; if [[ \"\${#COMP_WORDS[@]}\" == \"2\" ]]; then COMPREPLY=(\$(compgen -W \"$kubecall_cmds_string\" \"\${COMP_WORDS[1]}\")); return; fi; }; complete -F _kubecall_completions kubecall"

    touch $KUBECALL_AUTO_COMPLETE_FILE_NAME
    echo -n "Adding autocompletion for kubernetes contexts..."
    echo "$kubecall_autocomplete_fun_def" >> "$PWD/$KUBECALL_AUTO_COMPLETE_FILE_NAME"
    echo "source $PWD/$KUBECALL_AUTO_COMPLETE_FILE_NAME" >> ~/.bashrc
    echo "Done."

    echo -e $LINE_SEPERATOR
    echo "Enjoy a hassle free experience!"
}

function handle_add() {
    if [[ $1 == "add" ]]; then
        cp "$PWD/kubecall" "$KUBECALL_SCRIPT_PATH/kubecall"
        chmod 777 "$KUBECALL_SCRIPT_PATH/kubecall"
        create_update_kubecall_auto_complete_file
        echo "Done."
        exit 1
    fi
}

function handle_remove() {
    if [[ $1 == "remove" ]]; then
        rm -f "$KUBECALL_SCRIPT_PATH/kubecall"
        rm -f "$PWD/$KUBECALL_AUTO_COMPLETE_FILE_NAME"
        if grep -Fxq "source $PWD/$KUBECALL_AUTO_COMPLETE_FILE_NAME" ~/.bashrc
        then
            BASHRC_FILE_PATH=$(find ~/.bashrc)
            echo "$(grep -v "source $PWD/$KUBECALL_AUTO_COMPLETE_FILE_NAME" $BASHRC_FILE_PATH)" > "$BASHRC_FILE_PATH.bak"
            mv "$BASHRC_FILE_PATH.bak" "$BASHRC_FILE_PATH"
        else
            echo "autocompletion not present in bashrc, Skipping it."
        fi
        echo "Done."
        exit 1
    fi
}

function handle_help() {
    if [[ -z $1 ]] || [[ $1 == "help" ]]; then
        kubecall_setup_help
        exit 1
    fi
}

handle_help $@
if [ "$USER" != "root" ]; then
    echo "Please run this script with root..."
    exit 1
fi
handle_add $@
handle_remove $@