$tenantid = "123445567889"
$clientid = "123456"
$clientsecret = "abcd1234!235"

$response = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantid/oauth2/token" -Body @{ resource="https://storage.azure.com/"; grant_type="client_credentials"; client_id=$clientid; client_secret=$clientsecret }

$access_token = $response.access_token

$request_date = (get-date).toString("r")
$headers = @{
        'Authorization' = 'Bearer $access_token'
        'x-ms-version' = '2019-12-12'
        'x-ms-date' = '$request_date'
        }


$metadata_result = Invoke-RestMethod -Method Get -Uri "https://teststorageaccount.blob.core.windows.net/testcontainer?restype=container&comp=metadata" -Headers $headers
