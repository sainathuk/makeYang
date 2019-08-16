#!/bin/bash
if [ -f "$2" ]; then
  rm "$2";
fi
temp="/tmp/temp_input_temp"
cat $1 | sort > "$temp"
echo "  grouping mavenir-rcs-xxx-extensions {" >> "$2"
while IFS= read -r line; do
  #echo "tester: $line"
  vnfd=$(echo $line | awk -F ";" '{print $1}')
  elem=$(echo $line | awk -F ";" '{print $1}' | awk '{print tolower($0)}')
  elem=${elem//_/-}
  type=$(echo $line | awk -F ";" '{print $2}')
  if [ -z $type ]; then
    type="string";
  fi
  def=$(echo $line | awk -F ";" '{print $3}')
#  echo "$elem -- $type -- $def";
  echo "    leaf $elem {" >> "$2"
  echo "      type $type;" >> "$2"
  echo "      reference \"VNFD Parameter : $vnfd\";"  >> "$2"
  if [ ! -z $def ]; then
    echo "      default $def;" >> "$2"
  fi
  echo "    }"  >> "$2"
done < "$temp"
echo "  }" >> "$2"
if [ -f "$temp" ]; then
  rm "$temp"
fi
