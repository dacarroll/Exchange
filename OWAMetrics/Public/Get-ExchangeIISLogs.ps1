function Get-ExchangeIISLogs {
    [cmdletbinding()]
    param (
    )
    begin {}

    process {
        $ExchangeServers = Get-Content (Join-Path $PSScriptRoot '..\bin\Config.json') | ConvertFrom-Json
        $ExchangeServers
    }

    end {}
}