#!/bin/bash
if [ -f "$2" ]; then
  rm "$2";
fi
temp="/tmp/temp_input_temp"
cat $1 | sort > "$temp"
while IFS= read -r line; do
  #echo "tester: $line"
  vnfd=$(echo $line | awk -F ";" '{print $1}')
  elem=$(echo $line | awk -F ";" '{print $1}' | awk '{print tolower($0)}')
  elem=${elem//_/-}
  type=$(echo $line | awk -F ";" '{print $2}')
  if [ -z $type ]; then
    type="string";
  fi
#  echo "$elem -- $type";
  echo "        <additional-parameters>" >> "$2"
  echo "            <id>$vnfd</id>" >> "$2"
  echo "            <value>{$elem}</value>" >> "$2"
  echo "            <type>$type</type>" >> "$2"
  echo "        </additional-parameters>" >> "$2"
done < "$temp"
if [ -f "$temp" ]; then
  rm "$temp"
fi
