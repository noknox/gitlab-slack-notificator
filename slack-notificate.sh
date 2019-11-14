#/bin/bash

ARGS=""

while (( "$#" )); do
  case "$1" in
    -s|--slack_hook)
      SLACK_WEBHOOK=$2
      shift 2
      ;;
    -c|--channel)
      SLACK_CHANNEL=$2
      shift 2
      ;;
    -m|--message)
      MESSAGE=$2
      shift 2
      ;;
    -o|--color)
      MESSAGE_COLOR=$2
      shift 2
      ;;
    --) # End arg parsing
      shift
      break
      ;;
    -*|--*=) # Unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # Preserve positional arguments
      ARGS="$ARGS $1"
      shift
      ;;
  esac
done

case "$MESSAGE_COLOR" in
  good)
    MESSAGE_COLOR="#1CBF43"
    ;;
  warning)
    MESSAGE_COLOR="#FBC02D"
    ;;
  danger)
    MESSAGE_COLOR="#ED5C5C"
    ;;
esac

eval set -- "$ARGS"

function send_slack_notification() {
  MESSAGE="$MESSAGE \n"
  JSON='{"channel": "#'$SLACK_CHANNEL'", "attachments": [{"color": "'$MESSAGE_COLOR'", "blocks": [
    {
      "type": "section",
			"fields": [
        {
					"type": "mrkdwn",
					"text": "'$MESSAGE'"
				}
      ]
    },
		{
			"type": "section",
			"fields": [
				{
					"type": "mrkdwn",
					"text": "*Project:*\n<'$CI_PROJECT_URL'|'$CI_PROJECT_NAME'>"
				},
				{
					"type": "mrkdwn",
					"text": "*Job:*\n<'$CI_JOB_URL'|'$CI_JOB_ID'>"
				},
				{
					"type": "mrkdwn",
					"text": "*Branch:*\n'$CI_COMMIT_REF_NAME'"
				},
				{
					"type": "mrkdwn",
					"text": "*Message:*\n'$CI_COMMIT_MESSAGE'"
				}
			]
		},
    {
      "type": "actions",
			"elements": [
				{
					"type": "button",
					"text": {
						"type": "plain_text",
						"emoji": true,
						"text": "Visit Pipeline"
					},
					"style": "primary",
					"url": "'$CI_PIPELINE_URL'"
				}
			]
    }
	]}]}'

  curl -X POST -H 'Content-type: application/json' --data "$JSON" "$SLACK_WEBHOOK"
}

send_slack_notification