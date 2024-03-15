#!/usr/bin/python
# -*-coding:utf-8 -*

import sys

for line in sys.stdin:
    line = line.strip()
    line = line.split(",")

    # Anulowane lub przekierowane pomijamy
    if line[23] == '1' or line[24] == '1':
        continue

    # Klucz. Lotnisko + data (rok i miesiąc)
    airport_date = line[8] + '-' + line[0] + '-' + line[1]
    # Opóźnienie
    delay = line[22]

    print('{} {}'.format(airport_date, delay))
