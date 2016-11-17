<#
    Title: Domain Application Launcher
	Vdersion: 1.0
    Author: David Whitehead
	Copyright (c) David Whitehead
    Copyright license: MIT
    Description: a powershell script which makes it easier to run both sql server management studio and visual studio as a network user              
	Requires: windows, powrshell and visual studio and sql server management studio "if you want to use it for both"
	NOTE: for this to work, you will still need your machine registered to the domain.
#>

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

# Create an object to hold the pop-up dialog box.

$objForm = New-Object System.Windows.Forms.Form
$objForm.Text = "Select The Service You Want To Run"
$objForm.Size = New-Object System.Drawing.Size(300, 200)
$objForm.StartPosition = "CenterScreen"

# Create a label for the pop-up menu then attach it to the Drop-down List.

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10, 20)
$objLabel.Size = New-Object System.Drawing.Size(280, 20)
$objLabel.Text = "Please select a computer:"
$objForm.Controls.Add($objLabel)

# Populate the Drop-down list.

$objListBox = New-Object System.Windows.Forms.ListBox
$objListBox.Location = New-Object System.Drawing.Size(10, 40)
$objListBox.Size = New-Object System.Drawing.Size(260, 20)
$objListBox.Height = 80

[void] $objListBox.Items.Add("Visual Studio")
[void] $objListBox.Items.Add("Sql Server")

$objForm.Controls.Add($objListBox)

# If the Enter key is left-clicked, select the highlighted menu item then close the pop-up menu.

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({
if ($_.KeyCode -eq "Enter") { $x = $objListBox.SelectedItem; $objForm.Close() }
})

# If the Escape key is left-clicked, simply close the pop-up menu.

$objForm.Add_KeyDown({
if ($_.KeyCode -eq "Escape") { $objForm.Close() }
})

# Create an OK button.

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75, 120)
$OKButton.Size = New-Object System.Drawing.Size(75, 23)
$OKButton.Text = "OK"

# If the OK button is left-clicked, select the highlighted menu item then close the pop-up menu.

$OKButton.Add_Click({ $global:x = $objListBox.SelectedItem; $objForm.Close() })
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150, 120)
$CancelButton.Size = New-Object System.Drawing.Size(75, 23)
$CancelButton.Text = "Cancel"

# If the Cancel button is left-clicked, simply close the pop-up menu.

$CancelButton.Add_Click({ $objForm.Close() })
$objForm.Controls.Add($CancelButton)

# Shift the operating system focus to the pop-up menu then activate it — wait for the user response.

$objForm.Topmost = $True

$objForm.Add_Shown({ $objForm.Activate() })
[void] $objForm.ShowDialog()


$global:app = ""
if($global:x -eq "Visual Studio")
{
	$global:app = "devenv.exe"
}
if($global:x -eq "Sql Server")
{
	$global:app = "ssms.exe"
}

#Stores an empty string so it allows us to enter all the credentials not just the password
$x = "";

#Opens a powershell as that user and then executes the command to run visual studio or sql server 
Start-Process powershell.exe -Credential $x -NoNewWindow -ArgumentList "Start-Process $global:app -Verb runAs" -WorkingDirectory 'C:\Windows\System32'
