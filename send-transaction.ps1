param(
  [string]$HostName = "localhost",
  [int]$Port = 3000,
  [string]$Id = "tx_manual_1",
  [double]$Amount = 10000,
  [string]$User = "alice",
  [string]$Timestamp = (Get-Date).ToUniversalTime().ToString("s") + "Z"
)

$Body = @{ id = $Id; amount = $Amount; user = $User; timestamp = $Timestamp } | ConvertTo-Json

Invoke-RestMethod -Method Post -Uri "http://$HostName:$Port/transactions" -ContentType 'application/json' -Body $Body | ConvertTo-Json -Depth 5

