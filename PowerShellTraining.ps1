<#
    .SYNOPSIS
    Interactive PowerShell training material

    .DESCRIPTION
    Basic Powershell concepts, examples or solutions that can actually be ran and tested.

    .NOTES
    Author: Addison Mendoza
#>

#region Initial Tips

###################################################################
#                            Initial Tips                         #
###################################################################

<#
    PowerShell is a massive ever growing and evolving programming
    language. Just like many other programming languages out there, 
    it's almost impossible to know everything there is to know about 
    it. A better and more efficient approach that will give you a 
    competitive edge is to follow these key pillars of programming 
    with not only PowerShell but other languages as well.
    
    1. Have a plan and a purpose. ShadowIT may help companies in the 
    short run but hurts them in the long run. Make sure your solution: 
        - has purpose
        - doesn't reinvent the wheel
        - is well thought out with a project plan behind it

    2. Don't try to memorize every command - that's impossible. 
    Instead, just remember these heavily used commands that will get 
    the information for you: 
        - Get-Help
        - Get-Member
        - Get-Command

    3. Follow best programming practices
        - Comment your code
        - Don't overcomplicate your code with nested loops
        - Streamline if/elseif statements when possible
        - Follow proper variable and function naming standards
        - Always perform user input validation
        - Gracefully catch and handle errors whenever possible
        - Clean up unused code or variables to free system resources
        - Attempt to make your code as dynamic and scalable as possible

    4. Keep security in mind
        - Do not hard code any confidential or proprietary information
        - Compile and/or sign code whenever possible
        - Properly store code behind well configured Git repos
#>

#endregion

#region Variables

###################################################################
#                              Variables                          #
###################################################################
<#
    A variable is an item that can store data and be called upon
    The more variables created and more data stored within variables during a PowerShell session consumes more memory on a computer
    In some scenarios, it may be preferable to reuse or release variables (garbage cleanup) to prevent memory leaks and poor computer performance
#>

# ----------------------- Creating Variables -------------------- #
# Create and store information into a variable
# This method is the quick and easy method to create variables but it does not allow you to customize the variable
$Variable1 = "Let's store this sentence into this variable"

# Alternative way to create and store information into a variable using the PowerShell command New-Variable
# This way is longer but provides more features to customize your variable including the option to make it read only
New-Variable -Name Variable2 -Value "We'll store this sentence into a variable also" -Description "second variable to demo variable code" -Scope global -Option ReadOnly

# You can pipe data into a new variable
"Let's pipe this sentence into a new variable" | New-Variable -Name Variable3

# ------------------------ Variable Options --------------------- #
<#
    When creating variables using the New-Variable command, there are many options for the types of variables
    None - Sets no options. None is the default.
    ReadOnly - Can be deleted. Cannot be changed, except by using the Force parameter.
    Private - The variable is available only in the current scope.
    AllScope - The variable is copied to any new scopes that are created.
    Constant - Cannot be deleted or changed. Exists only in the current PS session and is destroyed upon termination of the session
#>

# ----------------------- Modifying Variables -------------------- #
# There are many ways to modify a variable (read further for examples) but here are a few
$Variable1 = "Let's change the value of this variable"
Set-Variable -Name Variable2 -Value "We'll also change this variable's value as well" -Option ReadOnly -Force
$Variable3 = $null # This clears the variable of any data (not the same as an empty string '') but does not delete the variable
"Let's pipe this new data into a variable" | Set-Variable -Name Variable3

# ------------------------ Calling Variables --------------------- #
# While there are many ways to call a variable, some methods are better suited for certain scenarios

# Just declaring the variable by itself is the same thing as returning the value of the variable from the script or function (read further)
# This is not suitable for displaying the value at that specific point in time of the script
$Variable1
$Variable2

# Writing variable to host, information, warning or error displays the value of that variable at the time the code executes
# Read further for the differences between the various write commands
Write-Host $Variable3

# Formatting a variable is another method to output data to the screen at the exact point in time the code excecutes without having the effects of a write command
$Variable1 | Format-List
$Variable2 | Format-Table

# ------------------------ Removing Variables --------------------- #
# Removing variables is important for not only security or memory consumption but for ease of troubleshooting as well

# Deletes the variable Variable2 from memory - the force switch must be called since the variable was previously created as readonly
Remove-Variable Variable2 -Force

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
# An array is a collection of items.

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
# PSCustomObject or PSObject is a collection of attributes and their values
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

# A method to construct an array of pscustomobjects
[pscustomobject[]]$Array5 = @(
    $PSCustomObject1,
    $PSCustomObject2,
    $PSCustomObject3
)

# Another method to construct an array of pscustomobjects by creating and converting hash tables within the array itself
[pscustomobject[]]$Array6 = @(
    [pscustomobject]@{
        ObjectName = 'obj1'
        ObjectSize = 'big'
    },
    [pscustomobject]@{
        ObjectName = 'obj2'
        ObjectSize = 'bigger'
    },
    [pscustomobject]@{
        ObjectName = 'obj3'
        ObjectSize = 'huge'
    }
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
$MultiplicationResult = 5*5

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


# ---------------------- Order of Operations ----------------- #
# parentheses () play an important role in the order of operations when it comes to operators

# Arithmetics in PowerShell also follow the order of operations so adding parentheses to a mathmatical equation can completely change the outcome
$ArithmeticResult1 = 15/(5-2)
$ArithmeticResult2 = 15/5-2

# Adding parentheses in comparator logic can also change the outcome of a true or false statement
# The below if/else statement does not contain parentheses and evaluates all three comparators against each other which results in a $true result
if ($ArithmeticResult1 -lt 2 -and $ArithmeticResult2 -gt 2 -or 'hot' -ne 'cold') {
    $true
}
else {
    $false
}

# The below if/else statement contain parentheses and evaluates the first comparator against the last two comparators which results in a $false result
if ($ArithmeticResult1 -lt 2 -and ($ArithmeticResult2 -gt 2 -or 'hot' -ne 'cold')) {
    $true
}
else {
    $false
}

#endregion

#region Variable Scope

###################################################################
#                            Variable Scope                       #
###################################################################
<#
    Scoping plays an important role within not only a script but a module as well.
    While there are three scope types, we will be focusing on just two: global & script
    Variables may or may not be accessible depending on where they live (are scoped)

    The importance as well as benefits of properly scoping your variables includes but is not limited to:
    - Data security
    - Processing performance
    - Scripting efficiency
    - Troubleshooting efficiency
#>

# ---------------------- Global Scope ----------------- #
<#
    Variables are considered within the "global" scope if they:
    - Are created in the root of a PowerShell session
    - Are declared as such using the $global: modifier

    Global scope variables can be used anywhere in the PowerShell session and within any function or script called upon by the session
    Global scope variables created using the $Global: modifier cannot be overwritten unless the modifier is used again when setting a new value
#>

# The variable $Variable1 created earlier in this script is considered a "global" scoped variable because it was created within the root of the script/outside of any function
# It can be used within any function that is created within this script
function Test-Scope1 {
    Write-Host "Variable1 value: $Variable1"
}
Test-Scope1

# The variable $Variable1 created earlier in this script is also considered "local" to the root of the script.
# A variable of the same name created within a function supersedes the variable created outside of the function because it is local to that scope of the function
# A variable created within a function will be destroyed when the function ends and does not overwrite a similarly named variable outside of the function unless the $script:  or $global: modifier is used
function Test-Scope2 {
    $Variable1 = 'This variable1 variable is local only to the Test-Scope2 function and will be destroyed when the function ends'
    Write-Host "Variable1 value (within function): $Variable1"
}
Test-Scope2
Write-Host "Variable1 value (outside function): $Variable1"

# A variable created within a function using the $Script: or $Global: modifier will overwrite any similarly named variable that was created outside of the function
$Variable4 = 'This is a script scope variable'
function Test-Scope3 {
    Write-Host "Original Variable4 value: $Variable4"
    $Global:Variable4 = 'Overwriting variable4 from within the function using the $Global: modifier'
}
Test-Scope3
Write-Host "New Variable4 value: $Variable4"

# ---------------------- Script Scope ----------------- #
# Work in progress

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

# Work in progress
#endregion