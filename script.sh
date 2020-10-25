#!/bin/sh

# Create variables
NOW_DATE=$(date +'%F')

# Download backup
github-backup --token $GITHUB_TOKEN --output-directory /tmp/gh-bk $BACKUP_FLAGS $GITHUB_USERNAME

# Create ZIP (optional)
if [ "$ZIP" == 1 ] ; then
    cd /tmp
    zip -r $ZIP_OPTIONS "gh-bk/"
    mv /tmp/1.zip /tmp/gh-bk-${NOW_DATE}.zip
fi

# Upload backup
if [ "$ZIP" == 1 ] ; then
    echo "Moving /tmp/gh-bk-${NOW_DATE}.zip to ${RCLONE_PATH}gh-bk-${NOW_DATE}.zip"
    rclone move -v "/tmp/gh-bk-${NOW_DATE}.zip" ${RCLONE_PATH}
else
    echo "Moving /tmp/gh-bk to ${RCLONE_PATH}gh-bk-${NOW_DATE}"
    rclone moveto -v "/tmp/gh-bk" ${RCLONE_PATH}gh-bk-${NOW_DATE}
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