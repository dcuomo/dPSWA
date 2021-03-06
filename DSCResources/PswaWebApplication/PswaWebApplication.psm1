function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure ,

        [System.String]
        $WebApplicationName = 'pswa'
    )

    Write-Verbose ".:: Starting Get ::. "
    
    $ExistingWebApp = Get-WebApplication -Name $WebApplicationName -ErrorAction SilentlyContinue
    If ($ExistingWebApp) { $ExistingWebApp = (($ExistingWebApp).Path).TrimStart('/') }
    
    $returnValue = @{ 
        Ensure = $Ensure
        WebApplicationName = $WebApplicationName
        ExistingWebApp     = $ExistingWebApp
    }
    
    $returnValue
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [System.String]
        $WebApplicationName,

        [System.String]
        $WebSiteName
    )

    Write-Verbose ".:: Starting Set ::. "

    $params = @()
    Switch ($Ensure) {        
        'Present' {
            if ($WebApplicationName) { $params  = @{ WebApplicationName = $WebApplicationName }}
            else { Write-Verbose -Message 'WebApplication not specified : Using Default WebApplication' }

            if ($WebSiteName)        { $params += @{ Website = $WebSiteName }}
            else { Write-Verbose -Message 'Website not specified : Using Default Website' }
            
            Install-PswaWebApplication @Params -UseTestCertificate
        }

        'Absent' {

            if ($WebApplicationName) { $params  = @{ WebApplicationName = $WebApplicationName }}
            if ($WebSiteName)        { $params += @{ Website = $WebSiteName }}
            
            Uninstall-PswaWebApplication @Params -DeleteTestCertificate
        }
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [System.String]
        $WebApplicationName = 'pswa' ,

        [System.String]
        $WebSiteName
    )

    Write-Verbose ".:: Starting Test ::. "

    $Get = Get-TargetResource -WebApplicationName $WebApplicationName -Ensure $Ensure
    
    Switch ( $Ensure ) {
        'Present' {
            If ($Get.ExistingWebApp -eq $WebApplicationName) { Return $true }
            Else { Return $false }        
        }
        'Absent' {
            If ($Get.ExistingWebApp -eq $WebApplicationName) { Return $false }
            Else { Return $true }
        }
    }
    
    $result
}

Export-ModuleMember -Function *-TargetResource
