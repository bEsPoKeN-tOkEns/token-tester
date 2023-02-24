#!/bin/bash
function_selector_0x=$1
amount_of_tokens=$2
token_names_csv=$3

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

# Initialize the HTML table
# Create a multi-line string using a here document
read -r -d '' static_html << EOM
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Token Tester Results</title>
    <style>
      /* Add some basic styling to the table */
      table {
        border-collapse: collapse;
        width: 100%;
      }
      th, td {
        text-align: left;
        padding: 8px;
      }
      th {
        background-color: #4CAF50;
        color: white;
      }
      tr:nth-child(even) {
        background-color: #f2f2f2;
      }
      /* Add some styling to the status column */
      .success {
        color: green;
        font-size: 1.5em;
      }
      .failure {
        color: red;
        font-size: 1.5em;
      }
    </style>
  </head>
  <body>
    <h1>Example Table</h1>
    <table>
      <tr>
        <th>Test</th>
        <th>Token</th>
        <th>Status</th>
      </tr>
EOM


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

    # write a table-row to the static HTML
    table_row=$(printf '<tr>
        <td>%s</td>
        <td>%s</td>
        <td><span class="%s">&#10004;</span></td>
      </tr>' "$function_name" "${token_names[$i]}" "$class")
    static_html+="$table_row"

done

# Close the HTML before writing to file
read -r -d '' close_html << EOM
    </table>
  </body>
</html>
EOM

# Append the closing HTML tags
static_html+="$close_html"

# Write the html file
echo "$static_html" > report.html
