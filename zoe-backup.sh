rsync -rlDczPv --delete-after ~/Desktop jayne.local:/srv/share/private/hortont/Backups/Zoe/
rsync -rlDczPv --delete-after ~/Pictures/ jayne.local:/srv/share/public/Pictures/
rsync -rlDczPv --delete-after ~/Documents jayne.local:/srv/share/private/hortont/Backups/Zoe/
rsync -rlDczPv --delete-after ~/Music/iTunes/iTunes\ Music/Music/ jayne.local:/srv/share/public/Music/
rsync -rlDczPv --delete-after /Library/Fonts jayne.local:/srv/share/private/hortont/Backups/Zoe/
rsync -rlDczPv --delete-after "/Users/hortont/Library/Application Support/Adium 2.0/" jayne.local:/srv/share/private/hortont/Backups/Kaylee/Logs/
#ssh jayne.local perl /srv/share/www/aperture/aperture.pl