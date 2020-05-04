#!/bin/bash
KUBECALL_SCRIPT_PATH="/usr/local/bin"
KUBECALL_AUTO_COMPLETE_FILE_NAME="auto_complete_kubecall"
LINE_SEPERATOR="\n"

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


function handle_add() {
    function get_global_definition() {
        global_definition+="declare -A deployments_map;"
        for i in $@
            do
                echo -n "$i..."
                result=$(kubectl  get deployments --context=$i -o=name | sort -n | tr "\n" " ")
                formatted_result=("${result//deployment.extensions\//}")
                global_definition+="deployments_map[\"$i\"]=\"$formatted_result\";"
                echo "Done"
            done
    }
    if [[ $1 == "add" ]]; then
        if grep "source $KUBECALL_SCRIPT_PATH/$KUBECALL_AUTO_COMPLETE_FILE_NAME" ~/.bashrc;then
            echo "exists"
        else
            echo "source $KUBECALL_SCRIPT_PATH/$KUBECALL_AUTO_COMPLETE_FILE_NAME" >> ~/.bashrc
        fi
        contexts=$(kubectl config get-contexts -o=name | tr "\n" " ")
        context_values=($contexts)
        context_keys=("${!context_values[@]}")

        echo -e $LINE_SEPERATOR
        kubectl config get-contexts -o=name | grep -n '^'
        echo -e $LINE_SEPERATOR

        echo -e "Preparing autocompletion for contexts and it's deployments"
        echo "skip contexts from autocompletion by entering comma seperated numbers or ranged numbers"
        echo "eg. 1-4,7-9,12,14 or press enter to continue with all contexts"

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
                        if [[ $i -le 0 ]]; then echo "Invalid Skipping option 0, exitting"; exit 0; fi;
                        echo -e "\t $(($j+1)). ${context_values[$j]}"
                        unset "context_values[$j]"
                    done
                else
                    if [[ $i -le 0 ]]; then echo "Invalid Skipping option 0, exitting"; exit 0; fi;
                    clustor_no=$((i-1))
                    echo "Skipping $i. ${context_values[$clustor_no]}"
                    unset context_values[$clustor_no]
                fi
            done

        if [[ ${#tbs[@]} > 0 ]]; then
            echo -e $LINE_SEPERATOR
        fi

        global_definition=()
        context_values=( "${context_values[@]}" )
        get_global_definition ${context_values[@]}

        echo "Script requires root access to write kubecall to $KUBECALL_SCRIPT_PATH, you may be prompted for password"
        sudo cp "$PWD/kubecall" "$KUBECALL_SCRIPT_PATH/kubecall"
        echo -n "Writing kubecall to system..."
        sudo chmod 775 "$KUBECALL_SCRIPT_PATH/kubecall"
        sudo cp "$PWD/kubecall_completion" "$KUBECALL_SCRIPT_PATH/$KUBECALL_AUTO_COMPLETE_FILE_NAME"
        sudo chmod 777 "$KUBECALL_SCRIPT_PATH/$KUBECALL_AUTO_COMPLETE_FILE_NAME"
        echo "$global_definition" >> "$KUBECALL_SCRIPT_PATH/$KUBECALL_AUTO_COMPLETE_FILE_NAME"
        echo "Done."

        echo -e $LINE_SEPERATOR
        echo "Enjoy a hassle free experience!"
        exit 1
    fi
}

function handle_remove() {
    if [[ $1 == "remove" ]]; then
        if grep -Fxq "source $KUBECALL_SCRIPT_PATH/$KUBECALL_AUTO_COMPLETE_FILE_NAME" ~/.bashrc
        then
            BASHRC_FILE_PATH=$(find ~/.bashrc)
            echo "$(grep -v "source $KUBECALL_SCRIPT_PATH/$KUBECALL_AUTO_COMPLETE_FILE_NAME" $BASHRC_FILE_PATH)" > "$BASHRC_FILE_PATH.bak"
            mv "$BASHRC_FILE_PATH.bak" "$BASHRC_FILE_PATH"
        else
            echo "autocompletion not present in bashrc, Skipping it."
        fi
        echo "Script requires root access to remove kubecall from $KUBECALL_SCRIPT_PATH, you may be prompted for password"
        sudo rm -f "$KUBECALL_SCRIPT_PATH/kubecall"
        sudo rm -f "$KUBECALL_SCRIPT_PATH/$KUBECALL_AUTO_COMPLETE_FILE_NAME"
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
if [ "$USER" == "root" ]; then
    echo "Please run this script without root..."
    exit 1
fi
handle_add $@
handle_remove $@
