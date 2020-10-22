function GetTrustStoreInformation()
{
    $KeyToolCommand = "C:\Program Files\Java\jre1.8.0_261\bin\keytool.exe"
    $TrustStoreLocation = "C:\Program Files\Java\jre1.8.0_261\lib\security\cacerts"
    $Password = "changeit"
    $results = $(& $KeyToolCommand -list -keystore $TrustStoreLocation -storepass "$Password" -v)
    
    $certificateList = @()

    $certificateAlias = ""
    $certificateValidDate = ""
    foreach($result in $results)
    {
        if($result.Contains("Alias name:"))
        {
            $certificateAlias = $result
        }
        if($result.Contains("Valid from:"))
        {
            $certificateValidDate = $result.Substring(48)
            $trustStoreCertificate =[pscustomobject]@{
                alias = $certificateAlias
                validDate = $certificateValidDate
            }
            $certificateList += $trustStoreCertificate
        }
    }   
    return $certificateList
}

$certificateList = GetTrustStoreInformation
foreach($certificate in $certificateList)
{
    Write-Host $certificate.alias
    Write-Host $certificate.validDate
}

