if [ $? -ne 0 ]; then

    echo "No incoming connection entries found in MongoDB log file."

    exit 1

fi