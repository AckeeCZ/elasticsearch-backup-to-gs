#!/bin/bash
set -eo pipefail

backup_tool="gsutil"

# verify variables
if [ -z "$GS_ACCESS_KEY" -o -z "$GS_SECRET_KEY" -o -z "$GS_URL" -o -z "$ELASTICSEARCH_URL" ]; then
	echo >&2 'Backup information is not complete. You need to specify GS_ACCESS_KEY, GS_SECRET_KEY, GS_URL, ELASTICSEARCH_URL. No backups, no fun.'
	exit 1
fi

# set gs config
echo -e "[Credentials]\ngs_access_key_id = $GS_ACCESS_KEY\ngs_secret_access_key = $GS_SECRET_KEY" > /root/.boto

SNAPSHOT_VOLUME=${SNAPSHOT_VOLUME-"/var/backup/elasticsearch"}

# verify GS config
$backup_tool ls "gs://$GS_URL" > /dev/null

# set cron schedule TODO: check if the string is valid (five or six values separated by white space)
[[ -z "$CRON_SCHEDULE" ]] && CRON_SCHEDULE='0 2 * * *' && \
   echo "CRON_SCHEDULE set to default ('$CRON_SCHEDULE')"

# add a cron job
echo "$CRON_SCHEDULE root /snapshotter.sh && $backup_tool mv ${SNAPSHOT_VOLUME} gs://$GS_URL/" >> /etc/crontab
crontab /etc/crontab

exec "$@"
