#!/usr/bin/env LC_ALL=en_US.UTF-8 /usr/local/bin/python3
#
# <bitbar.title>Yahoo Weather</bitbar.title>
# <bitbar.version>v3.0</bitbar.version>
# <bitbar.author>mgjo5899</bitbar.author>
# <bitbar.author.github>mgjo5899</bitbar.author.github>
# <bitbar.desc>It tells you the current weather condition of the location where your computer is located at.  It knows the location of the computer by using its public IP.  You can also manually set the city and region through modifying the file. </bitbar.desc>
# <bitbar.image>https://i.imgur.com/YNypf0P.jpg</bitbar.image>
# <bitbar.dependencies>python</bitbar.dependencies>
#
# by mgjo589
# tweaked by longpdo (https://github.com/longpdo)

import json
import uuid
import time
import hmac
import hashlib

from base64 import b64encode
from datetime import datetime
from urllib.request import urlopen, Request
from urllib.parse import urlencode, quote

# General Placeholders
url = 'https://weather-ydn-yql.media.yahoo.com/forecastrss'
method = 'GET'
concat = '&'

# Credentials
app_id = 'f776QQ32'
consumer_key = 'dj0yJmk9RlJhbUVpUEpsSUxEJmQ9WVdrOVpqYzNObEZSTXpJbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PTk0'
consumer_secret = '75c592717d22c5cce623d2c2a1d5a5b36786d865'

# Query and authentication related
query = {'location': f'Nuremberg,BY', 'format': 'json', 'u': 'c'}
oauth = {
    'oauth_consumer_key': consumer_key,
    'oauth_nonce': uuid.uuid4().hex,
    'oauth_signature_method': 'HMAC-SHA1',
    'oauth_timestamp': str(int(time.time())),
    'oauth_version': '1.0'
}


# Error handling decorator
def exception_handler(msg="Something is wrong"):
    def decorator(func):
        def new_func(*args, **kwargs):
            try:
                return func(*args, **kwargs)
            except:
                print(f"Error: {msg}")
                exit(1)
        return new_func
    return decorator


def get_auth_header():
    global oauth
    merged_params = query.copy()
    merged_params.update(oauth)
    sorted_params = [k + '=' + quote(merged_params[k], safe='')
                     for k in sorted(merged_params.keys())]
    signature_base_str = method + concat + \
        quote(url, safe='') + concat + quote(concat.join(sorted_params))
    composite_key = quote(consumer_secret, safe='') + concat
    oauth_signature = b64encode(hmac.new(composite_key.encode(
    ), msg=signature_base_str.encode(), digestmod=hashlib.sha1).digest()).decode()
    oauth['oauth_signature'] = oauth_signature
    auth_header = 'OAuth ' + \
        ', '.join(['{}="{}"'.format(k, v) for k, v in oauth.items()])

    return auth_header


@exception_handler(msg="Yahoo Weather API")
def get_weather(auth_header):
    request_url = url + '?' + urlencode(query)
    request = Request(request_url)
    request.add_header('Authorization', auth_header)
    request.add_header('X-Yahoo-App-Id', app_id)
    r = urlopen(request).read()
    j = json.loads(r)
    return j


auth_header = get_auth_header()
weather_data = get_weather(auth_header)
condition_text = weather_data['current_observation']['condition']['text']
condition_temperatur = weather_data['current_observation']['condition']['temperature']
forecasts = weather_data['forecasts']

print(str(condition_text) + ': ' + str(int(condition_temperatur)) + '°C')
# Dropdown info
print('---')
for day in forecasts:
    print(str(datetime.utcfromtimestamp(
        int(day['date'])).strftime('%A %d. %B')))
    print(str(day['text']) + ': ' + str(int(day['low'])) +
          '-' + str(int(day['high'])) + '°C')
    print('---')
