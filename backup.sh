rsync -rlDczPv --delete ~/Desktop/* Jayne.local:/srv/share/private/hortont/Backups/Kaylee/Desktop/
rsync -rlDczPv --delete ~/Code/* Jayne.local:/srv/share/public/Code/
rsync -rlDczPv --delete ~/Pictures/* Jayne.local:/srv/share/public/Photos/
rsync -rlDczPv --delete ~/Documents/* Jayne.local:/srv/share/private/hortont/Backups/Kaylee/Documents/
rsync -rlDczPv --delete ~/Music/* Jayne.local:/srv/share/private/hortont/Backups/Kaylee/Music/
rsync -rlDczPv --delete /Library/Fonts Jayne.local:/srv/share/private/hortont/Backups/Kaylee/
rsync -rlDczPv --delete /Applications Jayne.local:/srv/share/private/hortont/Backups/Kaylee/
rsync -rlDczPv --delete "/Users/hortont/Library/Application Support/Adium 2.0/" Jayne.local:/srv/share/private/hortont/Backups/Kaylee/Logs/
ssh Jayne.local perl /srv/share/www/aperture/aperture.pl
