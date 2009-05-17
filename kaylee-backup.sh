rsync -rlDczPv --delete-after ~/Desktop jayne.local:/srv/share/private/hortont/Backups/Kaylee/
rsync -rlDczPv --delete-after ~/Pictures/ jayne.local:/srv/share/public/Photos/
rsync -rlDczPv --delete-after ~/Documents jayne.local:/srv/share/private/hortont/Backups/Kaylee/
rsync -rlDczPv --delete-after ~/Music/iTunes/iTunes\ Music/ jayne.local:/srv/share/Public/Music/
rsync -rlDczPv --delete-after /Library/Fonts jayne.local:/srv/share/private/hortont/Backups/Kaylee/
rsync -rlDczPv --delete-after /Applications jayne.local:/srv/share/private/hortont/Backups/Kaylee/
rsync -rlDczPv --delete-after "/Users/hortont/Library/Application Support/Adium 2.0/" jayne.local:/srv/share/private/hortont/Backups/Kaylee/Logs/
ssh jayne.local perl /srv/share/www/aperture/aperture.pl
