"""
Hack script to upsert results into the json
"""
import json
import argparse
import json
import os
from htmltemplate import table_record, sub_header, html_template

# paths for file IO
current_dir = os.path.dirname(os.path.realpath(__file__))
out_dir = os.path.join(current_dir, 'python-out')

# arguments when invoking `python3 runner.py`
parser = argparse.ArgumentParser()
parser.add_argument('--test-name', type=str, required=True)
parser.add_argument('--token-name', type=str, required=True)
parser.add_argument('--result', type=str, required=True)

if __name__ == '__main__':
    args = parser.parse_args()
    json_path = os.path.join(out_dir, f'{args.test_name}-{args.token_name}.json')

    # write a test result to a unique json file
    with open(json_path, 'w') as f:
        json.dump({
            'test_name': args.test_name,
            'token_name': args.token_name,
            'result': args.result
        }, f, indent=4)

    # read all the json files in the output directory
    # parse the results into the HTML template
    data = []
    for fname in os.listdir(out_dir):
        fpath = os.path.join(out_dir, fname)
        with open(fpath, 'r') as f:
            data.append(json.load(f))

    table_records = []
    unique_test_names = sorted(set([result['test_name'] for result in data]))
    for test_name in unique_test_names:
        # append a sub header to the HTML table
        table_records.append(
            sub_header.format(test_name=test_name)
        )

        # filter for the specific test name
        test_results = filter(lambda x: x['test_name'] == test_name, data)
        # sort by result then token name
        test_results = sorted(test_results, key=lambda x: (x['result'], x['token_name']))
        [
            table_records.append(
                table_record.format(
                    test_name=result['test_name'],
                    token_name=result['token_name'],
                    token_file=result['token_name'],
                    dir_path=current_dir,
                    status=result['result'],
                    status_emoji='✅' if result['result'] == 'success' else '❌'
                )
            ) for result in test_results
        ]

    # convert python list to string
    table_records_str = ''.join(table_records)

    # update the HTML
    html_template = html_template.format(table_records=table_records_str)

    # write to the html file
    with open('report.html', 'w') as g:
        g.write(html_template)
