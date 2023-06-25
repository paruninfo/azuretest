$metadata_result = Invoke-RestMethod -Method GET -Headers @{"Metadata"="true"} -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01"  

$result_json = ConvertFrom-Json $appservice_data

#retrive specfic key

$location = $result_json.compute.location

Write-Host $location
