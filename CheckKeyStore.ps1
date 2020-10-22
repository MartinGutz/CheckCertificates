function GetTrustStoreInformation()
{
    $KeyToolCommand = "C:\Program Files\Java\jre1.8.0_261\bin\keytool.exe"
    $TrustStoreLocation = "C:\Program Files\Java\jre1.8.0_261\lib\security\cacerts"
    $Password = "changeit"
    $results = $(& $KeyToolCommand -list -keystore $TrustStoreLocation -storepass "$Password" -v)
    Write-Host $results
    foreach($result in $results)
    {
        if($result.Contains("Alias name:"))
        {
            Write-Host $result
        }
        if($result.Contains("Valid from:"))
        {
            Write-Host $result
        }
    }   
}

GetTrustStoreInformation

