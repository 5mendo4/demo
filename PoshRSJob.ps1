<#
    .SYNOPSIS
    Provides various examples of how to use Start-RSJob and its performance capabilities

    .DESCRIPTION
    Demonstrates 4 different methods for getting a list of AD group objects and their members.
    The first three examples use the PoshRSJob command to show the efficiency of parallel jobs
    The last example shows the ineffeciency of not using parallel jobs.

    .NOTES
    Author: Addison Mendoza
#>

Clear-Host

try {
    # Required module
    Import-Module activedirectory -ErrorAction stop

    #region Variables
    # Gets x number of AD group objects to leverage with PoshRSJob
    $Groups = Get-ADGroup -Filter * -ResultSetSize 20 -ErrorAction stop

    # Gets the domain controller that serves the PDC emulator
    $Server = (Get-ADDomainController -Filter {OperationMasterRoles -like '*pdcemulator*'} -ErrorAction stop).hostname
    #endregion

    #region Example 1
    #######################################
    #       PoshRSJob - Example 1         #
    #######################################
    <#
        This example demonstrates how to use start-rsjob by piping an array of objects into the command
        and leveraging the properties from the object(s) within each job.
    #>
    Write-Host "Measuring PoshRSJob - Example 1"
    $JobResults1 = @()
    $TestResults = Measure-Command -Expression {
    #region Example Code
        $JobResults1 = $Groups | Start-RSJob -Name $_.name -ScriptBlock {
            Get-ADGroupMember -Identity "$($_.samaccountname)"
        } | Wait-RSJob | Receive-RSJob
        Get-RSJob | Remove-RSJob
    #endregion
    }
    Write-Host "TotalTime(seconds): $($TestResults.TotalSeconds)"
    Write-Host "JobResults: $($JobResults1 | Measure-Object | Select-Object -ExpandProperty count)"
    #endregion

    #region Example 2
    #######################################
    #       PoshRSJob - Example 2         #
    #######################################
    <#
        This example demonstrates how to use start-rsjob by piping an array of objects into the command
        and also supplying arguments into the jobs' parameter.
    #>
    Write-Host "`nMeasuring PoshRSJob - Example 2"
    $JobResults2 = @()
    $TestResults = Measure-Command -Expression {
    #region Example Code
        $JobResults2 = $Groups | Start-RSJob -Name $_.name -ArgumentList $_.samaccountname -ScriptBlock {
            param ($SamAccountName)
            Get-ADGroupMember -Identity "$SamAccountName"
        } | Wait-RSJob | Receive-RSJob
        Get-RSJob | Remove-RSJob
    #endregion
    }
    Write-Host "TotalTime(seconds): $($TestResults.TotalSeconds)"
    Write-Host "JobResults: $($JobResults2 | Measure-Object | Select-Object -ExpandProperty count)"
    #endregion

    #region Example 3
    #######################################
    #       PoshRSJob - Example 3         #
    #######################################
    <#
        This example demonstrates how to use start-rsjob by piping an array of objects into the command
        and also referencing a variable outside of the job with the $using scope.
    #>
    Write-Host "`nMeasuring PoshRSJob - Example 3"
    $JobResults3 = @()
    $TestResults = Measure-Command -Expression {
    #region Example Code
        $JobResults3 = $Groups | Start-RSJob -Name $_.name -ScriptBlock {
            Get-ADGroupMember -Identity $_.samaccountname -Server $using:Server
        } | Wait-RSJob | Receive-RSJob
        Get-RSJob | Remove-RSJob
    #endregion
    }
    Write-Host "TotalTime(seconds): $($TestResults.TotalSeconds)"
    Write-Host "JobResults: $($JobResults3 | Measure-Object | Select-Object -ExpandProperty count)"
    #endregion

    #region Example 4
    #######################################
    #       PoshRSJob - Example 4         #
    #######################################
    <#
        This example demonstrates lack of performance while using a traditional foreach loop
        compared to the Start-RSJob command
    #>
    Write-Host "`nMeasuring foreach - Example 4"
    $JobResults4 = @()
    $TestResults = Measure-Command -Expression {
    #region Example Code
        $JobResults4 += $Groups | ForEach-Object {
            Get-ADGroupMember -Identity $($_.samaccountname)
        }
    #endregion
    }
    Write-Host "TotalTime(seconds): $($TestResults.TotalSeconds)"
    Write-Host "JobResults: $($JobResults4 | Measure-Object | Select-Object -ExpandProperty count)"
    #endregion
}
catch {
    throw $_
}