# Gitlab Slack Notificator

### How to use

`bash slack-notificate.sh --channel test --slack_hook https://hooks.slack.com/services/dsadsadsa/ASDYIDSAIBDIASSDS -o warning --message 'Waiting for deploy approval...'`

-c | --channel = Slack channel to send the notification  
-s | --slack_hook = Slack URL WebHook ( Use Slack incoming webhooks )  
-o | --color = Color to attach in slack message (good, warning, danger)  
-m | --message = Message to send in the notification header

The script will create a notification like this:  

![Screenshot](gitlab-slack-notificator.jpg)