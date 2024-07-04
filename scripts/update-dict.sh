#!/bin/bash

# Step 1: Read and format the contents of dict.txt
awk '{print "\x27" $0 "\x27"}' ./dict.txt | paste -sd, - > temp_new_dict.txt

# Step 2: Generate the new JavaScript array assignment and write to a temporary file
echo "var dictionary = ["$(<temp_new_dict.txt)"];" > temp_formatted_dict.js

# Step 3: Replace the existing dictionary in dict.js using awk and the temporary formatted dictionary file
awk 'BEGIN{new_dict=""; while(getline < "temp_formatted_dict.js") new_dict=new_dict $0} /var dictionary = \[/{p=1; print new_dict} !p' ./js/solver/dict.js > ./js/solver/temp.js && mv ./js/solver/temp.js ./js/solver/dict.js

# Cleanup
rm temp_new_dict.txt temp_formatted_dict.js

echo "The dictionary in dict.js has been updated."
