#!/usr/bin/python
# -*-coding:utf-8 -*

import sys

current_key = None
current_delay = 0
current_number = 0
airport_date = None

for line in sys.stdin:
    line = line.strip()
    airport_date, delay = line.split()

    try:
        delay = int(delay)
    except ValueError:
        continue

    if current_key == airport_date:
        current_delay += delay
        current_number += 1
    else:
        if current_key:
            airport, year, month = current_key.split("-")  # Rozdzielenie klucza składającego się z ID lotniska, roku i miesiąca
            print('{} {} {} {} {}'.format(airport, year, month, current_number, current_delay))
        current_delay = delay
        current_number = 1
        current_key = airport_date

if current_key == airport_date:
    airport, year, month = current_key.split("-")   # Rozdzielenie klucza składającego się z ID lotniska, roku i miesiąca
    print('{} {} {} {} {}'.format(airport, year, month, current_number, current_delay))
