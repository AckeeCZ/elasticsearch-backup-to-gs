Backup container for elasticsearch data directory
_________________________________________________

This image provides a cron daemon that runs daily backups from elasticsearch data directory to Google Storage.

Following ENV variables must be specified:

	ELASTICSEARCH_URL url with port where your elasticsearch runs, for example localhost:9200
    GS_URL contains address in GS where to store backups, without the `gs://` prefix
        bucket-name/directory
    GS_ACCESS_KEY
    GS_SECRET_KEY
    CRON_SCHEDULE cron schedule string, default '0 2 * * *'

Examples:

1) Run docker container with elasticsearch:

	docker run --name elasticsearch -v /var/backup/elasticsearch -p 9200:9200 -d elasticsearch -Des.path.repo=/var/backup/elasticsearch
2) And then run your elasticsearch-backup-to-s3 container:

	docker run --link elasticsearch:elasticsearch -e ELASTICSEARCH_URL="elasticsearch:9200" -e SNAPSHOT_VOLUME="/var/backup/elasticsearch" -e GS_URL="your GS url" -e GS_ACCESS_KEY="your GS access key" -e GS_SECRET_KEY="your GS secret key"
