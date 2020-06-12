#!/bin/sh
TMPDIR="/tmp/$(mktemp -u -d backups.$USER.XXXXXX)" && mkdir -p $TMPDIR
BUCKET="techevo-backups/$HOSTNAME-backups"
INVOCATION_ID=$(systemd-id128 new)
TIMESTAMP=$(date -u +%s)

_log () {
  printf "$1" | systemd-cat -t $(basename $0)
}

_cleanup () {
  _log "Cleaning up."
  rm -rf $TMPDIR
}

export -f _log

printf "$TMPDIR\n"
printf "$BUCKET\n"

_log "Starting backup."

trap _cleanup SIGINT

_log "Creating archive: $USER-$HOSTNAME-$TIMESTAMP.tar.gz"
tar -zcf "$TMPDIR/$USER-$HOSTNAME-$TIMESTAMP.tar.gz" "$HOME/Documents/" "$HOME/.vim" 2>/dev/null

if [ $? -eq 0 ]; then
  printf "Success\n"
  aws s3 cp "$TMPDIR/$USER-$HOSTNAME-$TIMESTAMP.tar.gz" s3://techevo-backups/
else
  _log "Unable to create archive locally.\n"
  _cleanup
fi

#_cleanup

_log "Finished backup."
