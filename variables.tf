variable "name" {
  type = "string"
  description = "name of lambda and SNS topic (suffix will be added to waranty uniqness)"
}

variable "webhook_path" {
  type = "string"
  description = "web_hook path where to post messages"
}

variable "account_number" {
  type = "string"
  description = "account on which you run. Needed for policy creation"
}

variable "notify_channel" {
  type = "string"
  description = "slack channel in which all notifications will be posted"
}

variable "error_channel" {
  default = ""
  type = "string"
  description = "slack channel in which only error notifications will be posted"
}

variable "username" {
  type = "string"
  default = "AWS Bot"
  description = "user name under which messeges will be posted"
}

variable "icon_emoji" {
  type = "string"
  default = ":aws:"
  description = "user icon from emoji list to show"
}