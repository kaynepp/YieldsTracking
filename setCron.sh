crontab -l > mycron; echo '* * * * * /root/tracking/quili/listening.sh' >> mycron; crontab mycron; rm mycron
crontab -l > mycron; echo '* * * * * /root/tracking/quili/rewards.sh' >> mycron; crontab mycron; rm mycron
crontab -l > mycron; echo '* * * * * /root/tracking/file-station/rewards.sh' >> mycron; crontab mycron; rm mycron
crontab -l > mycron; echo '* * * * * /root/tracking/aioz/rewards.sh' >> mycron; crontab mycron; rm mycron
crontab -l > mycron; echo '* * * * * /root/tracking/0g/check.sh' >> mycron; crontab mycron; rm mycron
