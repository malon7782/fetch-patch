#!/bin/bash

INPUT=$1
NAME=$2

if [ -z "$INPUT" ]; then
    echo "error: missing argument"
    exit 1
fi

find "/home/malon/Desktop/thunderbird/common/.thunderbird/qy2c99g2.default/Mail/Local Folders" -maxdepth 1 -type f -mtime +4 ! -name "*.msf" | while read -r f; do
    rm -f "$f" "${f}.msf"
done

killall thunderbird 2>/dev/null || true
sleep 0.42

if [[ "$INPUT" == http* ]]; then
    MSG_ID=$(echo "$INPUT" | sed -E 's|.*lore\.kernel\.org/[^/]+/([^/]+).*|\1|')
else
    MSG_ID=$INPUT
fi

if [ -z "$NAME" ]; then
    NAME="patch_$(date +%m%d_%H%M)"
fi

echo "Message-ID: $MSG_ID"
echo "File name: $NAME"

wget -qO "/tmp/${NAME}.mbox.gz" "https://lore.kernel.org/git/${MSG_ID}/t.mbox.gz"

if [ $? -ne 0 ]; then
    echo "error: unable to download"
    rm -f "/tmp/${NAME}.mbox.gz" 
    exit 1
fi

gunzip -f "/tmp/${NAME}.mbox.gz"
DIR="/home/malon/Desktop/thunderbird/common/.thunderbird/qy2c99g2.default/Mail/Local Folders"


rm -f "$DIR/{%NAME}.msf"

mv "/tmp/${NAME}.mbox" "$DIR/$NAME"

nohup thunderbird >/dev/null 2>&1 & disown

