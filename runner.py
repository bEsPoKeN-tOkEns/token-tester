"""
Hack script to upsert results into the json
"""
import json
import argparse
import json
import os
import threading
import time
from htmltemplate import table_record, html_template

# paths for file IO
current_dir = os.path.dirname(os.path.realpath(__file__))
json_path = os.path.join(current_dir, 'data.json')

# arguments when invoking `python3 runner.py`
parser = argparse.ArgumentParser()
parser.add_argument('--test-name', type=str, required=True)
parser.add_argument('--token-name', type=str, required=True)
parser.add_argument('--result', type=str, required=True)

lock = threading.Lock()

if __name__ == '__main__':
    args = parser.parse_args()

    # create the file if it doesnt exist
    # if not os.path.exists(json_path):
    #     with open(json_path, 'w') as f:
    #         json.dump([], f)

    # open the json file for upsertion
    with open(json_path, 'r') as f:
        for _ in range(1000):
            try:
                lock.acquire()
                break
            except:
                time.sleep(2)
        data = json.load(f)

    # upsert {test_name, token_name, result} into data.json
    # Beware: this is modifying `data`` in-place
    existing = list(filter(lambda x: x['test_name'] == args.test_name and x['token_name'] == args.token_name, data))
    if len(existing) == 0:
        data.append({'test_name': args.test_name, 'token_name': args.token_name, 'result': args.result})
    else:
        existing[0]['result'] = args.result
    
    # sort based on test_name and token_name
    data = sorted(data, key=lambda x: (x['test_name'], x['token_name']))

    # create the table records (format HTML)
    table_records = [
        table_record.format(
            test_name=result['test_name'],
            token_name=result['token_name'],
            token_file=result['token_name'],
            dir_path=current_dir,
            status=result['result']
        ) for result in data
    ]

    # convert python list to string
    table_records_str = ''.join(table_records)

    # update the HTML
    html_template = html_template.format(table_records=table_records_str)


    with open(json_path, 'w') as f:
        json.dump(data, f, indent=4)
        lock.release()

    # write to the html file
    with open('report.html', 'w') as g:
        g.write(html_template)
