[CmdletBinding()]
Param (
    [Parameter(Position=1)]
    [string]
    $hostName = "192.168.40.4",
    [Alias("u")] [string]
    $username,
    [Alias("p")] [string]
    $password, 
    [string]
    $scriptRoot = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\schema"),
    [string]
    $cqlsh = 'cqlsh',
    [Alias("e")] [string]
    $environment = 'prod',
    [int]
    $start = 1
)

Function FilterStart {
    Process {
        $parts = $_.Name.Split("_")
        
        if(($parts[0] -as [int]) -ge $start){
            $_
        }
    }
}


Function FilterEnvironment { 
   
   Process {
    $parts = $_.Name.Split(".")
    
    if(!$environment){
        $_
        return
    }


    if($parts.length -gt 2){
        if($parts[-2] -eq $environment){
            $_
        }
    } else{
        $_
    }
   }
}

Function RunCql {
    Process {
        & $cqlsh $hostName -u $username -p $password -f $_.FullName
    }
}


gci $scriptRoot |
FilterStart |
FilterEnvironment |
Sort-Object Name |
RunCql




