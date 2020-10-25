#!/bin/sh

# Create variables
nowDate=$(date +'%F')

# Download backup
github-backup --token $GITHUB_TOKEN --output-directory /tmp/gh-bk $BACKUP_FLAGS $GITHUB_USERNAME

# Create ZIP (optional)
if [ "$ZIP" == 1 ] ; then
    cd /tmp
    zip -r $ZIP_OPTIONS "gh-bk/"
    mv /tmp/1.zip /tmp/gh-bk-${nowDate}.zip
fi

# Upload backup
if [ "$ZIP" == 1 ] ; then
    echo "Moving /tmp/gh-bk-${nowDate}.zip to ${RCLONE_PATH}gh-bk-${nowDate}.zip"
    rclone move -v "/tmp/gh-bk-${nowDate}.zip" ${RCLONE_PATH}
else
    echo "Moving /tmp/gh-bk to ${RCLONE_PATH}gh-bk-${nowDate}"
    rclone moveto -v "/tmp/gh-bk" ${RCLONE_PATH}gh-bk-${nowDate}
fi

# Delete old
if [ "$DAYS_TO_KEEP" != 0 ] ; then
    if [ "$ZIP" == 1 ] ; then
        OLD_DATE=$(date --date="${DAYS_TO_KEEP} days ago" +'%F')
        echo "Deleting ${RCLONE_PATH}gh-bk-${OLD_DATE}.zip"
        rclone deletefile ${RCLONE_PATH}gh-bk-${OLD_DATE}.zip
    else
        echo "Deleting ${RCLONE_PATH}gh-bk-${OLD_DATE}"
        rclone delete ${RCLONE_PATH}gh-bk-${OLD_DATE}
    fi
fi

# Cleanup
rm -rf /tmp/gh-bk*