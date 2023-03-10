table_record = """
    <tr>
        <td>{test_name}</td>
        <td><a href="vscode://file{dir_path}/lib/weird-erc20/src/{token_file}.sol">{token_name}</a></td>
        <td><span class="{status}">{status_emoji}</span></td>
    </tr>
"""

sub_header = """
      <tr>
        <th class="subheader">{test_name}</th>
        <th class="subheader"></th>
        <th class="subheader"></th>
      </tr>
"""

html_template ="""
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Token Tester Results</title>
    <style>
      /* Add some basic styling to the table */
      table {{
        border-collapse: collapse;
        width: 100%;
      }}
      th {{
        text-align: left;
        padding: 8px;
        font-size: 1.2em;
      }}
      td {{
        text-align: left;
        padding: 8px;
      }}
      th {{
        background-color: #777;
        color: white;
      }}
      tr:nth-child(even) {{
        background-color: #444;
      }}
      tr:nth-child(odd) {{
        background-color: #333;
      }}
      /* Add some styling to the status column */
      .subheader {{
        background-color: #565f89;
        color: white;
      }}
      .success {{
        color: #9ece6a;
        font-size: 1.5em;
      }}
      .failure {{
        color: #f7768e;
        font-size: 1.5em;
      }}
      body {{
        width: 66%;
        text-align: center;
        margin: 0 auto;
        color: #fff;
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        background-color: #222;
      }}
      a {{
        color: #00a3ff;
      }}
    </style>
  </head>
  <body>
    <h1>Token Tester Results</h1>
    <table>
      <tr>
        <th>Test</th>
        <th>Token</th>
        <th>Status</th>
      </tr>
      {table_records}
    </table>
  </body>
</html>
"""