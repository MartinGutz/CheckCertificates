function Get-PublicKey
{
    [OutputType([byte[]])]
    PARAM (
        [Uri]$Uri
    )

    if (-Not ($uri.Scheme -eq "https"))
    {
        Write-Error "You can only get keys for https addresses"
        return
    }

    $request = [System.Net.HttpWebRequest]::Create($uri)

    try
    {
        #Make the request but ignore (dispose it) the response, since we only care about the service point
        $request.GetResponse().Dispose()
    }
    catch [System.Net.WebException]
    {
        if ($_.Exception.Status -eq [System.Net.WebExceptionStatus]::TrustFailure)
        {
            #We ignore trust failures, since we only want the certificate, and the service point is still populated at this point
        }
        else
        {
            #Let other exceptions bubble up, or write-error the exception and return from this method
            throw
        }
    }

    #The ServicePoint object should now contain the Certificate for the site.
    $servicePoint = $request.ServicePoint
    return $servicePoint.Certificate.GetExpirationDateString()
}

function ParseCertExpirationDate($dateString)
{
    [datetime]$parsedDate = $dateString
    return $parsedDate
}

function GetDaysCertIsStillValid($date)
{
    $currentDate = Get-Date
    return (New-TimeSpan -Start $currentDate -End $date).Days
}


$siteList = @()

$siteList += "https://www.google.com"
$siteList += "https://www.cnn.com"

$siteExpirationDates = @()

foreach($site in $siteList)
{
    $validDate = Get-PublicKey $site
    $certExpirationDate = (ParseCertExpirationDate $validDate)
    $siteExpirationInformation =[pscustomobject]@{
        siteName = $site
        certExpirationDate =  $certExpirationDate
        validDays = (GetDaysCertIsStillValid $certExpirationDate)
    }
    $siteExpirationDates += $siteExpirationInformation
}


foreach($site in $siteExpirationDates)
{
    Write-Host "Site:" $site.siteName
    Write-Host "Expiration Date:" $site.certExpirationDate
    Write-Host "Valid Days:" $site.validDays
}

