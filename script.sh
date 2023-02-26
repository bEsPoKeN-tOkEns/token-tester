#!/bin/bash
function_selector_0x=$1
amount_of_tokens=$2
token_names_csv=$3

# current directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# split the token names into an array, using comma delimiter
IFS=',' read -r -a token_names <<< "$token_names_csv"
for element in "${token_names[@]}"
do
    echo "$element"
done

# parse additional input
amount_of_tokens=${amount_of_tokens#*x}
function_selector=${function_selector_0x#*x}
function_selector=${function_selector%*00000000000000000000000000000000000000000000000000000000}

# search for the human-readable function name from the foundry out/ ABI
function_name=$(grep -r "${function_selector}" out | grep "test" | cut -d: -f2 | cut -d\" -f2 | cut -d\( -f1 )


# use for loop based on range 0..$2
# start at 1 because forge test treats 0 = no token
for i in $(seq 1 1 $amount_of_tokens)
do
    FORGE_TOKEN_TESTER_ID=$i forge test --mt $function_name --silent --ffi > /dev/null 2>&1
    result=$(echo $?)
    echo $result "Token ${token_names[$i-1]}"

    # ternary conversion of exit code to `success` or `failure`
    # (exit code 0 is success, 1 is failure)
    class=$( [ "${result}" -eq 1 ] && echo "failure" || echo "success" )

    python3 $DIR/runner.py --test-name $function_name --token-name ${token_names[$i-1]} --result $class
    wait
done

