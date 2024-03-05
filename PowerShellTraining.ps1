<#
.SYNOPSIS
Interactive PowerShell training material

.DESCRIPTION
Basic Powershell concepts, examples or solutions that can actually be ran and tested.

.NOTES
Author: Addison Mendoza
#>

#region Variables

###################################################################
#                              Variables                          #
###################################################################
<#
    A variable is an item that can store data and be called upon
    The more variables created and more data stored within variables during a PowerShell session consumes more memory on a computer
    It's best practice to re-use or release variables (garbage cleanup) to prevent memory leaks and poor computer performance
#>

# Store information into a variable
$Variable1 = "Let's store this sentence into this variable"

# Call upon variable
$Variable1

#endregion

#region Quotes

###################################################################
#                                Quotes                           #
###################################################################
<#
    Single and double quotes can and are used interchangeably
    There are different scenarios and reasons why you may want to use one style of quotes over another
    Not understanding when to use the proper style of quotes can break a script and even provide completely inaccurate data
#>

# Single quotes - used when you don't want to recognize characters or variables
$Quotes1 = 'This will not show the sentence of variable1: $Variable1'

# Double quotes - used when you want to replace the variable name with its contents or recognize other characters
$Quotes2 = "This will show the sentence of the Variable1: $Variable1"

#endregion

#region Data Types

###################################################################
#                              Data Types                         #
###################################################################
<#
    When creating a variables, it's always best practice to declare a variable a certain data type.
    This is important for many reasons, one reason being for data validation against another user running the script
    While there are many data types in PowerShell, we'll cover some of the more popular ones
    PowerShell has the ability to assume certain data types but sometimes it's wrong which is another reason why declaring the data type is important
    Once you specify a variable as a specific data type, it's not easy nor is it recommended to change the type down the road
#>

# String data type - w/o specifying a data type, PowerShell will assume this sentence is a string because it's in quotes
$DataType1 = 'this is a string'

# String data type - a string is also assumed here with double quotes
$DataType2 = "ThisIsAStringAsWell"

# String data type - specifying the data type as a string helps for data validation
[string]$DataType3 = "this is also a string"

# Char data type - single letter. w/o specifying a char data type, PowerShell will assume this is a string. There may be times where we want to validate that only a single character is assigned to a variable
[char]$DataType4 = 'a'

# Int32 data type - even though the number in not in quotes and PowerShell assumes a number not in quotes is an integer, we specify that it's an int32 to esure data validation
[int32]$DataType5 = 45

# String data type - even though the number is not in quotes, we specified the data type as string for data validation
[string]$DataType6 = 45

# Int32 data type - even though we wrapped the number in quotes, we specify the data type to be of type int32 for data validation
[int32]$DataType7 = "45"

# String data type - w/o specifying a data type, PowerShell will assume this number is a string because we wrapped it in quotes
$DataType8 = "45"

# PSCredential data type - a data type specific to PowerShell that contains a custom credential object consisting of username and encrypted password
[pscredential] $DataType9 = (Get-Credential -Message 'type anything for username and password')

# Bool data type - True or False value - By default, variables of type bool are false by default until specified true
[bool] $DataType10 = $true

#endregion

#region Arrays HashTables Objects

###################################################################
#                   Arrays, Hash Tables & Objects                 #
###################################################################

# ------------------------------ Array -------------------------- #
# Array is a collection of items.

# One way to create an array is wrap your items in @() - PowerShell assumes the data type for $Array1 is an array because of this
$Array1 = @(
'apple',
'banana',
'pear'
)

# Another way to create an array is to list them as such - In this example, we specify the data type as an array for data validation
[array]$Array2 = 'item1','item2','item3'

# Another way to specify the data type as an array is by specifying what the data type is for the items in the array followed by []
# This is a common method but requires all items in said array to be of the same data type - good to validate user input

# All items in this array must be of type string
[string[]]$Array3 = 'item1','item2','item3'

# All items in this array must be of type pscredential
[pscredential[]]$Array4 = (Get-Credential -Message "fake creds 1" -UserName "creds1"),(Get-Credential -Message "fake creds 2" -UserName "creds2"),(Get-Credential -Message "fake creds 3" -UserName "creds3")

# ------------------------- Hash Table -------------------------- #
# Hash Table is a collection of name/key - value pairs and is constructed with @{}
# Unlike an array, you do not separate items with a comma

# Simple hash table construction
$HashTable1 = @{
    VehicleType='car'
    Color='blue'
    TopSpeedMPH='135'
}

# Created an empty hash table - then adds key/value pairs
$HashTable2 = @{}
$HashTable2.Add('VehicleType','Plane')
$HashTable2.Add('Color','Pink')
$HashTable2.Add('TopSpeedMPH','900')

# ----------------------------- Objects ------------------------- #
# PS Custom Object or PS Object is a collection of attributes and their values
# While a hash table and object may seem similar, their data is constructed and accessed differently
# PSObject vs PSCustomObject data types - These data types are essentially the same. Both are constructed the same and leveraged the same. However, the key differences is that the PSCustomObject data type is only available for PowerShell version 3.0 onward and processes faster than its predecessor, PSObject
# PSCustomObject should ALWAYS be chosen over PSObject as long as your PS version permits

# Create a PSCustomObject using easiest method - This method leverages the shorter and faster typed structure of a hash table but then converts it to a pscustomobject by specifying the data type as such
$PSCustomObject1 = [pscustomobject]@{
    VehicleType='car'
    Color='blue'
    TopSpeedMPH='135'
}

# Create a PSCustomObject using the longer method by creating the object then adding each member individually
$PSCustomObject2 = New-Object PSCustomObject
$PSCustomObject2 | Add-Member -MemberType NoteProperty -Name VehicleType -Value boat
$PSCustomObject2 | Add-Member -MemberType NoteProperty -Name Color -Value yellow
$PSCustomObject2 | Add-Member -MemberType NoteProperty -Name TopspeedMPH -Value 45

# Converts the previously created hash table to a pscustomobject
$PSCustomObject3 = [pscustomobject]$HashTable2

# (pre PS 3.0) Create a PSObject using the longer method by creating the object then adding each member individually
$PSObject = New-Object PSObject
$PSObject | Add-Member -MemberType NoteProperty -Name VehicleType -Value car
$PSObject | Add-Member -MemberType NoteProperty -Name Color -Value red
$PSObject | Add-Member -MemberType NoteProperty -Name TopspeedMPH -Value 125

# Array of pscustomobjects
[pscustomobject[]]$Array5 = @(
    $PSCustomObject1,
    $PSCustomObject2,
    $PSCustomObject3
)

#endregion

#region Operators

###################################################################
#                              Operators                          #
###################################################################
<#
    Operators are elements within PS that let you perform various actions including but not limited to
    - Arithmetics
    - Logics
    - Data assignments
    - Comparison
#>

# ---------------------------- Arithmetic ----------------------- #
# Operators used for calculating numbers
$AdditionResult = 1 + 2
$SubtractionResult = 1 - 2
$DivisionResult = 10/2

# ---------------------------- Assignment ----------------------- #
# Operators used for managing variables

# Set a string value to a variable
$AssignmentVariable1 = 'This guy'

# Add a string value to a variable
$AssignmentVariable1 += ' is cool'

# Set a number value to a variable
$AssignmentVariable2 = 1

# Add 1 to a variable
$AssignmentVariable2 += 1

# Add 1 to a variable
$AssignmentVariable2 ++

# Remove 1 from a variable
$AssignmentVariable2 -= 1

# Remove 1 from a variable
$AssignmentVariable2 --

# ---------------------------- Comparison ----------------------- #
# Operators used to compare variables/values and test conditions - These return a true or false value

# Compares two different strings which returns a bool value of $false
'apple' -eq 'orange'

# Compares the same number which returns a bool value of $true
2 -eq 2

# Tests if 2 is greater than 1 which returns a bool value of $true
2 -gt 1

# Tests if 4 is greater than or equal to an integer declared value of 3 which returns $true
4 -ge [int]"3"

# Tests if the two strings are equal including letter capitalization
'McDonald' -ceq 'mcdonald'

# Tests if one string is like another by use of the wildcard *
'hotDogTrain' -like 'hotdog*'

# ---------------------------- Logics ----------------------- #
# Logic operators test logical statements to see if they are true or false

# Tests if the string 'apple' is in the list/array of strings
@('orange','apple','pear') -contains 'apple'
'test' -in @('orange','apple','pear')


#endregion

#region Variable Scope

###################################################################
#                            Variable Scope                       #
###################################################################

#endregion

#region Functions

###################################################################
#                              Functions                          #
###################################################################

# ----------------------- Processing Methods -------------------- #
function Test-FunctionProcessingMethods {
    [cmdletbinding()]

    param (
        [parameter(ValueFromPipeline=$true)][string[]]$array
    )

    begin {
        Write-Host "Begin block is only processed once"
    }
    process {
        Write-Host "Processing $_"
    }
    end {
        Write-Host "End block is only processed once "
    }
}
#endregion