Param(
	[string]$region
)

#$region = "ap-southeast-2"

Set-StrictMode -Version Latest

$message  = 'Warning!'
$question = 'This script will delete EVERY SQS queue it finds, regardless if there are messages in them! Are you sure you want to delete EVERY SQS queue in the ' + $region + ' region ?'

$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes, delete EVERY queue'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$decision = $Host.UI.PromptForChoice($message, $question, $choices, 1)
if ($decision -ne 0) {
  return 
}

Import-Module AWSPowershell

$accessKey = $env:AWS_ACCESS_KEY_ID
$secretKey = $env:AWS_SECRET_ACCESS_KEY

foreach( $q in Get-SQSQueue -AccessKey $accessKey -SecretKey $secretKey -Region $region )
{
    Remove-SQSQueue -QueueUrl $q -AccessKey $accessKey -SecretKey $secretKey -Region $region -Force
}

