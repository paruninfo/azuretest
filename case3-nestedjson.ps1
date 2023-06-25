function jsondata
{
$appservice_data = @'
{
  "appservice":{
        "properties":{
            "platform": "windows",
            "tlsversion": "1.2",
            "appserviceplan": "P2v2"
                     }
               },
         "resources":{
              "name": "az-eus2-app-testapp",
              "resourcegroup": "az-eus2-rg-testapp",
              "region": "east-us2"
                     }
}
'@
 
$result = ConvertFrom-Json $appservice_data

$platform_name = $result.appservice.properties.platform
$tls_version = $result.appservice.properties.tlsversion
$region = $result.resources.region


Write-Host $platform_name
Write-Host $tls_version
Write-Host $region

}

#call the function
jsondata
