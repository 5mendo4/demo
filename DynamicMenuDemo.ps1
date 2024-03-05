<#
  .SYNOPSIS
  Demos the funciton, Invoke-DynamicMenu

  .DESCRIPTION
  Shows off the capabilities of the Invoke-DynamicMenu function with various sample data types

  .NOTES
  Author: Addison Mendoza
#>

#--------------- Main Function --------------#
function Invoke-DynamicMenu {
  <#
      .SYNOPSIS
      Dynamically creates a menu, based on information provided. 

      .DESCRIPTION
      DynamicMenu is meant to be an all inclusive support function
      that accepts data of a specific type and generates an interactive
      menu. Accepted data types are: arrays, hash tables, psobjects, 
      and a root word string of other function names.

      .PARAMETER MainmenuFunction
      Function to be called when main menu option is chosen

      .PARAMETER MenuPrompt
      Verbiage displayed at the top of the menu

      .PARAMETER RootFunction
      A root word that other function names start with 
      for the menu to pull and allow the user to run

      .PARAMETER Option1
      Action performed when option 1 is chosen: "MainMenu", "Exit" or "Back"

      .PARAMETER StringArray
      Accepts data of basetype system.array in the form of simple strings

      .PARAMETER HashTable
      Accepts data of type hash table and displays those items in the menu
      
      .PARAMETER DisplayKeys
      Choose this if you want the items being displayed for a hash table to
      be the keys and not the values
      
      .PARAMETER DisplayValues
      Choose this if you want the items being displayed for a hash table to
      be the values and not the keys
      
      .PARAMETER ObjectArray
      Accepts data of basetype system.array in the form of psobjects or pscustomobjects
      
      .PARAMETER DisplayProperty
      Specify which psobject property you want displayed as menu items
      
      .EXAMPLE
      Invoke-DynamicMenu -Option1 MainMenu -MenuPrompt "Make a selection" -RootFunction "DM_Demo_" -MainMenuFunction 'Invoke-MainMenuFunction'
      
      .EXAMPLE
      Invoke-DynamicMenu -Option1 Back -StringArray $Array -MainMenuFunction 'Invoke-MainMenuFunction'
      
      .EXAMPLE
      Invoke-DynamicMenu -Option1 Exit -HashTable $HashTable -DisplayKeys -MainMenuFunction 'Invoke-MainMenuFunction'
      
      .EXAMPLE
      Invoke-DynamicMenu -Option1 Back -ObjectArray $PSObject -DisplayProperty VehicleType -MainMenuFunction 'Invoke-MainMenuFunction'
      
      .NOTES
      Author:  Addison Mendoza
  #>

  [cmdletbinding(defaultparametersetname="function")]

  param(
      [parameter(HelpMessage="Main Menu function")]
      [string]$MainMenuFunction, #Use this to specify the function name you want ran when selecting main menu

      [parameter(HelpMessage="Custom menu prompt")]
      [string]$MenuPrompt, #Use this to specify a custom menu prompt at the top of the menu  
      
      [parameter(mandatory,parametersetname="function",HelpMessage="Root word of commands you want to populate the menu with")]
      [string]$RootFunction, #Use this to specify a root keyword which will cause the menu to populate with any function that starts with that root keyword.
      
      [parameter(mandatory,parametersetname="o-hash",HelpMessage="Specify if option1 should be MainMenu or Exit or Back")]
      [parameter(mandatory,parametersetname="o-object",HelpMessage="Specify if option1 should be MainMenu or Exit or Back")]
      [parameter(mandatory,parametersetname="o-array",HelpMessage="Specify if option1 should be MainMenu or Exit or Back")]
      [parameter(mandatory,parametersetname="o-hash1",HelpMessage="Specify if option1 should be MainMenu or Exit or Back")]
      [parameter(mandatory,parametersetname="o-hash2",HelpMessage="Specify if option1 should be MainMenu or Exit or Back")]
      [parameter(mandatory,parametersetname="function",HelpMessage="Specify if option1 should be MainMenu or Exit or Back")]
      [ValidateSet("Main Menu", "Exit", "Back")]
      [string]$Option1, #Use this to specify a command(string) to have option 1 execute (input command that was previously ran before this one to simulate going back one screen)
      
      [parameter(mandatory,parametersetname="array",HelpMessage="Specify if the information provided is an array")]
      [parameter(mandatory,parametersetname="E-array",HelpMessage="Specify if the information provided is an array")]
      [parameter(mandatory,parametersetname="o-array",HelpMessage="Specify if the information provided is an array")]
      [string[]]$StringArray, #accepts a variable that is an array,
      
      [parameter(mandatory,parametersetname="hash",HelpMessage="Specify if the information provided is a hash table")]
      [parameter(mandatory,parametersetname="E-hash",HelpMessage="Specify if the information provided is a hash table")]
      [parameter(mandatory,parametersetname="o-hash",HelpMessage="Specify if the information provided is a hash table")]
      [parameter(mandatory,parametersetname="hash1",HelpMessage="Specify if the information provided is a hash table")]
      [parameter(mandatory,parametersetname="hash2",HelpMessage="Specify if the information provided is a hash table")]
      [parameter(mandatory,parametersetname="o-hash1",HelpMessage="Specify if the information provided is a hash table")]
      [parameter(mandatory,parametersetname="o-hash2",HelpMessage="Specify if the information provided is a hash table")]
      [parameter(mandatory,parametersetname="E-hash1",HelpMessage="Specify if the information provided is a hash table")]
      [parameter(mandatory,parametersetname="E-hash2",HelpMessage="Specify if the information provided is a hash table")]
      [hashtable]$HashTable, #accepts a variable that is a hash table (will need to choose either the hashkey or hashvalue switch)
      
      [parameter(mandatory,parametersetname="hash1",HelpMessage="Displays the keys as menu options")]
      [parameter(mandatory,parametersetname="E-hash1",HelpMessage="Displays the keys of a hash table as menu options")]
      [parameter(mandatory,parametersetname="o-hash1",HelpMessage="Displays the keys of a hash table as menu options")]
      [switch]$DisplayKeys, #add this switch if you want the menu option to display the hash key text
      
      [parameter(mandatory,parametersetname="hash2",HelpMessage="Displays the values of a hash table as menu options")]
      [parameter(mandatory,parametersetname="E-hash2",HelpMessage="Displays the values of a hash table as menu options")]
      [parameter(mandatory,parametersetname="o-hash2",HelpMessage="Displays the values of a hash table as menu options")]        
      [switch]$DisplayValues, #add this switch if you want the menu option to display the has value text

      [parameter(mandatory,parametersetname="object",HelpMessage="Specify if the information provided is a psobject")]
      [parameter(mandatory,parametersetname="E-object",HelpMessage="Specify if the information provided is a psobject")]
      [parameter(mandatory,parametersetname="o-object",HelpMessage="Specify if the information provided is a psobject")]        
      [pscustomobject[]]$ObjectArray, #accepts a variable that is a custom ps object (will need to use the psobjectkey parameter)

      [parameter(mandatory,parametersetname="object",HelpMessage="Specify the property of a psobject to display as menu options")]
      [parameter(mandatory,parametersetname="E-object",HelpMessage="Specify the property of a psobject to display as menu options")]
      [parameter(mandatory,parametersetname="o-object",HelpMessage="Specify the property of a psobject to display as menu options")]        
      [string]$DisplayProperty #use this parameter to specify a property in the object that you want to display as the menu item text
  )

  #Creates menu object
  $Menu = @()
  $i = 1

  #Creates menu items based on input type except for option 1
  if ($StringArray) {
      # Menu options will be an array of strings
      $Items = $StringArray

      # Parse through the items/array and add each one as a menu option
      foreach ($Item in $Items) {
          $i ++
          $Menu += [pscustomobject]@{
              OptionNumber = $i
              OptionDescription = $Item
          }
      }
  }
  elseif ($HashTable) {
      # Menu options will be a hash table

      # Converts the hash table into a pscustomobject and stores it into items for easier parsing later
      $Items = [pscustomobject]$HashTable

      # Gets all the properties of the items
      $Properties = $Items | Get-Member -MemberType noteproperty | select-object -ExpandProperty name

      # Parse through the properties
      foreach ($Property in $Properties) {
          $i++
          $Key = $Property
          $Value = $Items.$Key

          # Create a menu item based on the current property and add it to the menu
          $Menu += [pscustomobject]@{
              OptionNumber = $i
              OptionDescription = if ($DisplayKeys) {$Key} else {$Value}
              Key = $Key
              Value = $Value
          }
      }
  }
  elseif ($ObjectArray) {
      # Menu options will be pscustomobjects

      # Store all objects in the array as is into the menu array
      $Menu = $ObjectArray | select-object *

      # Parse through each item in the current menu array
      foreach ($Item in $Menu) {
          $i ++

          # If the current item's option number is NOT 1, set the option description as the property that the user chose to display
          if ($_.optionnumber -ne 1) {
              $OptionDescription = $Item | select-object -ExpandProperty $DisplayProperty
          }

          # Add two extra property members to the current item in the menu
          $Item | Add-Member -MemberType NoteProperty -Name OptionNumber -Value $i -ErrorAction SilentlyContinue
          $Item | Add-Member -MemberType NoteProperty -Name OptionDescription -Value $OptionDescription -ErrorAction SilentlyContinue
      }
  }
  else {
      # Menu options will be function names

      # Get all functions within scope that start with the provided root function prefix and store their names into an array
      $Items = Get-Command "$RootFunction*" | select-object  name | sort-object name

      # Parse through the array of function names
      foreach ($Item in $Items) {
          $i ++
          
          # Build pscustomobjects that contain the function name and add it as an item to the menu
          $Menu += [pscustomobject]@{
              OptionNumber = $i
              OptionFunction = $Item.name
              OptionDescription = $Item.name -replace "$RootFunction",""
          }
      }
  }

  #Creats menu option 1
  $Menu += [pscustomobject]@{
      OptionNumber = 1
      OptionDescription = $Option1
  }

  # Build the menu and prompt for a choice until the user enters a valid choice
  Do {
      clear-host

      #Sets verbiage at top of menu
      if ($MenuPrompt) {
        Write-Host $MenuPrompt
      }
      else {
        Write-Host "Make a selection"
      }

      # Now we display the menu
      foreach ($item in $Menu | Sort-Object optionnumber) {
          # Formats the spacing after menu option numbers so the options are all lined up evenly
          if ($OptionNumber -ge 100) {
              Write-Host "$($item.OptionNumber).   $($item.OptionDescription)"
          }
          elseif ($OptionNumber -le 9) {
              Write-Host "$($item.OptionNumber).  $($item.OptionDescription)"
          }
          else {
              Write-Host "$($item.OptionNumber). $($item.OptionDescription)"
          }
      }

      # Prompt for the user to make a choice and validate that choice
      try {
          [ValidateScript({([int]$_ -ge 1) -and ([int]$_ -le $Menu.count) })]$Choice = Read-Host "Choice"
          Write-Information "Choice: $Choice"
          $InputOK = $true
      }
      catch {
          $InputOK = $false
      }
  }until ($InputOK)

  # Parse through each item in the shown menu
  foreach ($Item in $Menu) {
      # If the current menu item option number equals the choice number the user chose, take action
      # This is important because w/o this the script may call a previous menu item from a different menu
      if ($Choice -eq $Item.OptionNumber) {            
          switch ($Item.OptionDescription) {
              'Exit' {
                  # Simulate a "ctrl + c" key combo to exit the menu and not the entire powershell instance
                  [System.Windows.Forms.SendKeys]::SendWait("^+{c}")
              }
              'Main Menu' {
                  # Go back to the root of the menu
                  &$MainmenuFunction
              }
              'Back' {
                  # Go back just one menu level or to the previous menu
                  &$Option1
              }
              default {
                  #If option 1 was not chosen then the script needs to run a function or choose a menu item respectively
                  if ($RootFunction) {
                      # Run the function that the user chose
                      &$Item.OptionFunction
                  }
                  else {
                      # Return the chosen menu item/object
                      return ($Menu | where-object {$_.OptionNumber -eq $Choice} | select-object *)
                  }
              }
          }
      }
  }
}

#------------ Functions for Demo ------------#

Function DM_Demo_TestFunction1 {
Write-Host "Running test function 1"
}

Function DM_Demo_TestFunction2 {
Write-Host "Running test function 2"
}

Function DM_Demo_TestFunction3 {
Write-Host "Running test function 3"
}

Function DM_Demo_TestFunction4 {
Write-Host "Running test function 4"
}

Function DM_DemoInfo {
  [cmdletbinding()]

  param(
      [parameter(mandatory,ParameterSetName="set1")]
      [switch]$StringArray,
      [parameter(mandatory,ParameterSetName="set2")]
      [switch]$HashTable,
      [parameter(mandatory,ParameterSetName="set3")]
      [switch]$ObjectArray
  )

  if ($StringArray) {
      #Create sample test array for purpose of demo-ing dynamic menu
      [array]$DemoItem = @('item1','item2','item3')
      return $DemoItem
  }
  elseif ($ObjectArray) {
      #Create sample test array of pscustomobjects for purpose of demo-ing dynamic menu
      [pscustomobject[]]$DemoItem = @()

      $DemoItem += [pscustomobject]@{
          VehicleType='Car'
          Size='Small'
          Color='Red'
          Cost = '$35,000'
      }

      $DemoItem += [pscustomobject]@{
          VehicleType='Plane'
          Size='Medium'
          Color='White'
          Cost = '$250,000'
      }

      $DemoItem += [pscustomobject]@{
          VehicleType='Boat'
          Size='Large'
          Color='Brown'
          Cost = '$467,000'
      }

      return $DemoItem
  }
  else {
      #Create sample hash table to purpose of demo-ing dynamic menu
      [hashtable]$DemoItem = @{key1="value1";key2="value2"}
      return $DemoItem
  }
}

Function Invoke-MainMenuFunction {
  [cmdletbinding()]

  param ()

  $FunctionParams = @{
      MainMenuFunction='Invoke-MainMenufunction'
      Option1='Main Menu'
  }

  $MenuType = Invoke-DynamicMenu -Option1 Exit -StringArray @("Root Function","String Array","Hash Table","Object Array") -MenuPrompt "What type of dynamic menu would you like to demo?" -MainMenuFunction 'Invoke-MainMenuFunction'


  switch ($MenuType.OptionDescription) {
      'Root Function' {
          Invoke-DynamicMenu @FunctionParams -RootFunction "DM_Demo_" -MenuPrompt "Select a function to run"
      }
      'String Array' {
          Invoke-DynamicMenu @FunctionParams -StringArray (DM_DemoInfo -StringArray) -MenuPrompt "Select a string from the array"
      }
      'Hash Table' {
          Invoke-DynamicMenu @FunctionParams -HashTable (DM_DemoInfo -HashTable) -DisplayKeys -MenuPrompt "Select a key from the hash table"
      }
      'Object Array' {
          Invoke-DynamicMenu @FunctionParams -ObjectArray (DM_DemoInfo -ObjectArray) -DisplayProperty "VehicleType" -MenuPrompt "Select an object from the array"
      }
  }
}

#--------------- Initiate Demo --------------#

Invoke-MainMenuFunction