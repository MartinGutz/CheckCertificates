function GetMonthNumber($monthInitials)
{
    SWITCH($monthInitials) {
    "Jan" { return "01"}
    "Feb" { return "02"}
    "Mar" { return "03"}
    "Apr" { return "04"}
    "May" { return "05"}
    "Jun" { return "06"}
    "Jul" { return "07"}
    "Aug" { return "08"}
    "Sep" { return "09"}
    "Oct" { return "10"}
    "Nov" { return "11"}
    "Dec" { return "12"}
    }
}

function ParseExpirationDate($string)
{
    $dateSubstring = $string.Substring(48)
    Write-Host $dateSubstring
    $expirationDate = ( GetMonthNumber $dateSubstring.SubString(4,3)) + "/" + $dateSubstring.SubString(8,2) + "/" + $dateSubstring.SubString(24,4)
    Write-Host $expirationDate
    [datetime]$parsedDate = $expirationDate
    Write-Host $parsedDate
    return $parsedDate
}
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
            $certificateValidDate = ParseExpirationDate $result
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

