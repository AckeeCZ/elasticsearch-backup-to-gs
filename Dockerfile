FROM debian:jessie

# backups to Google Storage
RUN apt-get update && apt-get install -y python python-pip cron curl && easy_install -U pip && pip2 install gsutil && rm -rf /var/lib/apt/lists/*

# entrypoint, snapshotter
COPY entrypoint.sh /entrypoint.sh
COPY snapshotter.sh /snapshotter.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["cron","-f"]
