#!/usr/bin/env bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

LOCKFILE="/tmp/fetch_snap.isrunning"
CAMADDR=( 172.16.5.1 \
		172.16.5.2 \
		172.16.5.3 \
		172.16.5.4 \
		172.16.5.5 \
		172.16.5.6 \
		172.16.5.7 \
		172.16.5.8 \
		172.16.5.10 \
		172.16.5.12 \
		172.16.5.15 \
		172.16.5.16 \
		172.16.5.17 \
		172.16.5.19 \
		172.16.5.20 \
		172.16.5.22
		)
CAMID="camadmin"
CAMPASS="IiZUKa68"
SAVEPATH="./"

# LOCK
if [ ! -e $LOCKFILE ]
then
	echo $$ >"$LOCKFILE"
else
	PID=$(cat "$LOCKFILE")
	if /bin/kill -0 "$PID" >&/dev/null
	then
		echo "fetch_snap.sh is still running"
		exit 0
	else
		echo $$ >"$LOCKFILE"
		echo "Warning: previous snapping appears to have not finished correctly"
	fi
fi

# get current time
YEAR=`date +%Y`
MON=`date +%m`
DAY=`date +%d`
HOUR=`date +%H`
MIN=`date +%M`

# make directory
mkdir -p $SAVEPATH/$YEAR/$MON/$DAY/$HOUR/$MIN/

# save snaps
for (( i = 0; i < ${#CAMADDR[*]}; i++ ))
{
	CAMNAME=`echo ${CAMADDR[i]} | cut -d '.' -f 4`
	curl -o $SAVEPATH/$YEAR/$MON/$DAY/$HOUR/$MIN/$YEAR-$MON-$DAY-$HOUR-$MIN-`printf "%02d" ${CAMNAME}`.jpg --connect-timeout 3 http://${CAMID}:${CAMPASS}@${CAMADDR[i]}/SnapshotJPEG?Quality=Clarity 2>/dev/null && echo "Fetched: webcam${CAMNAME}"
}

rm -f "$LOCKFILE"
