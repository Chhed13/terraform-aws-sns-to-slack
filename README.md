# Terraform module which creates AWS SNS endpoint to post to Slack
<img src="https://www.shareicon.net/data/128x128/2015/08/28/92269_copy_512x512.png" width="128px"> 
<img src="http://iosicongallery.com/img/128/slack-2014.png" width="128px">
<img src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="520px">

# Input variables

| Variable       |  Type  |  Default  | Description                                                             |
|----------------|:------:|:---------:|-------------------------------------------------------------------------|
| name           | string |           | name of lambda and SNS topic (suffix will be added to waranty uniqness) |
| webhook_path   | string |           | web_hook path where to post messages                                    |
| account_number | string |           | account on which you run. Needed for policy creation                    |
| notify_channel | string |           | Slack channel in which all notifications will be posted                 |
| error_channel  | string |    ""     | Slack channel in which only error notifications will be posted          |
| username       | string | "AWS Bot" | user name under which messeges will be posted                           |
| icon_emoji     | string |  ":aws:"  | user icon from emoji list to show                                       |


# Output variables

| Variable              |  Type  | Description                                     |
|-----------------------|:------:|-------------------------------------------------|
| sns_arn               | string | ARN of SNS topic to post messages               |
| lambda_arn            | string | ARN of lambda that will implement Slack posts   |
| lambda_version        | string | Version of lambda. Just for help purposes       |
| lambda_publich_status | string | Public status of lambda. Just for help purposes |

#Notification levels
Now 3 levels are supported: OK, WARN, ERROR. In OK - message is quoted with green line, in WARN - with orange, 
in ERROR - with red.

In ERROR state if `error_channel` is provided - message duplicates to it  

Current logic is:
* by default message status is OK
* if subject or text contains WARN (case insensitive) text - status WARN
* if subject or text contains ERROR (case insensitive) text - status ERROR

# Usage
## Implement in your environment
* copy/paste this code into some.tf file and fill the x's with real numbers
```
module "someSlackNotify" {
  source = "./../SNStoSlack"
  name = "someSlackNotify"
  webhook_path = "/services/xxxxxx/xxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxx"
  account_number = "XXXXXXXXXXXX"
  notify_channel = "#notify_channel"
  error_channel = "#error_channel"
}
```
* run `terraform init`
* run `terraform apply`
* remember, save or pass further via terraform_remote_state `sns_arn` output to post on it  

## Posting
### Via preconfigured AWS services
There a lot of AWS services that need only arn of SNS topic for posting - find this field and pase `sns_arn` into it

### Via Python SDK boto3 example
```
import boto3
import json

client = boto3.client('sns')
response = client.publish(
    TargetArn = os.environ['SNS_ARN'],
    Subject = "Message header",
    Message = json.dumps({'default': "message text"}),
    MessageStructure = 'json'
```
