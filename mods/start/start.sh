#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
source /pg/mods/functions/.master.sh

variable () {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

# What Loads the Order of Execution
primestart(){
  start_basics
  menuprime
}

menuprime() {
# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 $transport | Version: $pgnumber | ID: $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵 PG Disk Used Space: $used of $capacity | $percentage Used Capacity
EOF

  # Displays Second Drive If GCE
  edition=$(cat /pg/var/pg.server.deploy)
  if [ "$edition" == "feeder" ]; then
    used_gce=$(df -h /mnt | tail -n +2 | awk '{print $3}')
    capacity_gce=$(df -h /mnt | tail -n +2 | awk '{print $2}')
    percentage_gce=$(df -h /mnt | tail -n +2 | awk '{print $5}')
    echo "   GCE Disk Used Space: $used_gce of $capacity_gce | $percentage_gce Used Capacity"
  fi

  disktwo=$(cat "/pg/var/hd.path")
  if [ "$edition" != "feeder" ]; then
    used_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $3}')
    capacity_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $2}')
    percentage_gce2=$(df -h "$disktwo" | tail -n +2 | awk '{print $5}')

    if [[ "$disktwo" != "/pg" ]]; then
    echo "   2nd Disk Used Space: $used_gce2 of $capacity_gce2 | $percentage_gce2 Used Capacity"; fi
  fi

  # Declare Ports State
  ports=$(cat /pg/var/server.ports)

  if [ "$ports" == "" ]; then ports="[OPEN] Ports  "
else ports="[CLOSED] Ports"; fi

start_quotes

tee <<-EOF

[1]  Traefik   : Reverse Proxy   |  [6]  Press: Word Press Deployment
[2]  Port Guard: $ports  |  [7]  Vault: Backup & Restore
[3]  Shield : Google Protection  |  [8]  Cloud: Deploy GCE & Hetzner
[4]  Clone  : Mount Transport    |  [9]  Tools: Misc Products
[5]  Box    : Apps ~ Programs    |  [10] Settings
[Z]  Exit

"$quote"

$source
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  # Standby
read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
      bash /pg/stage/pgcloner/traefik.sh
      primestart ;;
    2 )
      bash /pg/stage/pgcloner/portguard.sh
      primestart ;;
    3 )
      bash /pg/stage/pgcloner/pgshield.sh
      primestart ;;
    4 )
      bash /pg/stage/pgcloner/pgclone.sh
      primestart ;;
    5 )
      bash /pg/stage/pgcloner/apps.sh
      primestart ;;
    6 )
      bash /pg/stage/pgcloner/pgpress.sh
      primestart ;;
    7 )
      bash /pg/stage/pgcloner/pgvault.sh
      primestart ;;
    8 )
      bash /pg/pgblitz/menu/interface/cloudselect.sh
      primestart ;;
    9 )
      bash /pg/pgblitz/menu/tools/tools.sh
      primestart ;;
    10 )
      bash /pg/pgblitz/menu/interface/settings.sh
      primestart ;;
    z )
      bash /pg/stage/files/ending.sh
      exit ;;
    Z )
      bash /pg/stage/files/ending.sh
      exit ;;
    * )
      primestart ;;
esac
}

primestart
