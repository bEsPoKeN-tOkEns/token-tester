#!/bin/bash
function_selector_0x=$1
amount_of_tokens=$2
amount_of_tokens=${amount_of_tokens#*x}
function_selector=${function_selector_0x#*x}
function_selector=${function_selector%*00000000000000000000000000000000000000000000000000000000}
# echo $function_selector

function_name=$(grep -r "${function_selector}" out | grep "test" | cut -d: -f2 | cut -d\" -f2 | cut -d\( -f1 )
# echo $function_name

# use for loop based on range 0..$2
# for i in {1..$amount_of_tokens}
for i in $(seq 1 1 $amount_of_tokens)
do
    FORGE_TOKEN_TESTER_ID=$i forge test --mt $function_name --silent --ffi > /dev/null 2>&1
    echo $?
done