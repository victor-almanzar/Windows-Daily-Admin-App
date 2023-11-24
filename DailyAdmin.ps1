Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$form = New-Object System.Windows.Forms.Form
$form.Text = "My WinForm Application"
$form.Size = New-Object System.Drawing.Size(900, 600)
$form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E") # Dark gray background
$form.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF") # White text

# Create a MessageBox with the notice text
$noticeText = "NOTICE: Unauthorized access to this system is forbidden and " +
              "will be prosecuted.`nBy accessing this system, you agree that " +
              "your actions may be monitored if unauthorized usage is suspected."

[System.Windows.Forms.MessageBox]::Show(
    $noticeText, 
    "Notice", 
    [System.Windows.Forms.MessageBoxButtons]::OK, 
    [System.Windows.Forms.MessageBoxIcon]::Information
)

# Create a sidebar listbox 200px wide and as tall as the form
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(0,0)
$listBox.Width = 200
$listBox.Dock = 'Left'
$listBox.SelectionMode = 'One'
$listBox.BorderStyle = 'None'
$listBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#252526") # Darker gray background for the sidebar
$listBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF") # White text
$listBox.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$form.Controls.Add($listBox)

# Create Panel 1 and add it to the form
$panel1 = New-Object System.Windows.Forms.Panel
$panel1.Size = New-Object System.Drawing.Size(700, 600)
$panel1.Location = New-Object System.Drawing.Point(200, 0)
$panel1.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E")
$panel1.Visible = $false
# Add unique controls to Panel 1 here
$label = New-Object System.Windows.Forms.Label
$label.Text = "This is Panel 1"
$label.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF")
$label.Location = New-Object System.Drawing.Point(10, 10)
$panel1.Controls.Add($label)
$form.Controls.Add($panel1)

# Create Panel 2 and add it to the form
$panel2 = New-Object System.Windows.Forms.Panel
$panel2.Size = New-Object System.Drawing.Size(700, 600)
$panel2.Location = New-Object System.Drawing.Point(200, 0)
$panel2.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E")
$panel2.Visible = $false
# Add unique controls to Panel 2 here
$label2 = New-Object System.Windows.Forms.Label
$label2.Text = "This is Panel 2"
$label2.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF")
$label2.Location = New-Object System.Drawing.Point(10, 10)
$panel2.Controls.Add($label2)
$form.Controls.Add($panel2)

# And so on for the other panels...

# Create five items in the listbox
$listBox.Items.AddRange(('Panel 1', 'Panel 2', 'Panel 3', 'Panel 4', 'Panel 5'))

# Add a SelectedIndexChanged event handler to the listbox
$listBox.Add_SelectedIndexChanged({
    # Hide all panels
    $panel1.Visible = $false
    $panel2.Visible = $false
    # And so on for the other panels...

    # Show the panel corresponding to the selected item
    switch ($listBox.SelectedIndex) {
        0 { $panel1.Visible = $true }
        1 { $panel2.Visible = $true }
        # And so on for the other panels...
    }
})

# Show the form
$form.ShowDialog()