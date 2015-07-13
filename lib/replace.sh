#!/usr/bin/env bash

sed  -e 's/内蒙古/&自治区/g' -e 's/西藏/&自治区/g' -e 's/广西/&壮族自治区/g' -e 's/宁夏/&回族自治区/g' -e 's/新疆/&维吾尔自治区/g' -e 's/\s*CZ88\.NET//g' -e 's/香港/&特别行政区/g' -e 's/澳门/&特别行政区/g' abc.txt > abc_bak.txt
