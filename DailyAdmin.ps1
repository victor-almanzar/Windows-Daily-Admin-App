# this improves the apps DPI scaling
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class DpiAwareness {
    [DllImport("user32.dll", SetLastError = true)]
    private static extern bool SetProcessDPIAware();

    public static void SetDpiAwareness() {
        SetProcessDPIAware();
    }
}
"@ 

[DpiAwareness]::SetDpiAwareness()

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Create a new form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Daily Admin"
$form.Size = New-Object System.Drawing.Size(900, 600)
$form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E") # Dark gray background
$form.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF") # White text
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# Create the banner form
$bannerForm = New-Object System.Windows.Forms.Form
$bannerForm.Text = "Notice"
$bannerForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$bannerForm.Size = New-Object System.Drawing.Size(600, 300)
$bannerForm.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E")

# Add the notice text
$noticeLabel = New-Object System.Windows.Forms.Label
$noticeLabel.Text = "NOTICE: Unauthorized access to this system is forbidden and " +
                    "will be prosecuted. By accessing this system, you agree that " +
                    "your actions may be monitored if unauthorized usage is suspected."
$noticeLabel.AutoSize = $false
$noticeLabel.Dock = [System.Windows.Forms.DockStyle]::Fill
$noticeLabel.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF")
$noticeLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$noticeLabel.Padding = New-Object System.Windows.Forms.Padding(16)
$bannerForm.Controls.Add($noticeLabel)

# Add the OK button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Dock = [System.Windows.Forms.DockStyle]::Bottom
$okButton.Height = 30
$okButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E")
$okButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF")
$okButton.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$okButton.Add_Click({ $bannerForm.Close() })
$bannerForm.Controls.Add($okButton)

# Show the form
$bannerForm.ShowDialog()

# Create a sidebar listbox 200px wide and as tall as the form
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(0,0)
$listBox.Width = 200
$listBox.Dock = 'Left'
$listBox.SelectionMode = 'One'
$listBox.BorderStyle = 'None'
$listBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#252526") # Darker gray background for the sidebar
$listBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF") # White text
$listBox.Font = New-Object System.Drawing.Font("Segoe UI", 16)
$form.Controls.Add($listBox)

# Create Panel 1 and add it to the form
$ResetUnlock = New-Object System.Windows.Forms.Panel
$ResetUnlock.Size = New-Object System.Drawing.Size(700, 600)
$ResetUnlock.Location = New-Object System.Drawing.Point(200, 0)
$ResetUnlock.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E")
$ResetUnlock.Visible = $false
# Add unique controls to Panel 1 here
$label = New-Object System.Windows.Forms.Label
$label.Text = "This is Panel 1"
$label.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF")
$label.Location = New-Object System.Drawing.Point(10, 10)
$ResetUnlock.Controls.Add($label)
$form.Controls.Add($ResetUnlock)

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

# Create a hashtable to map listbox items to panels
$panelMap = @{
  'Reset & Unlock' = $ResetUnlock
  'Create Account' = $panel2
  # Add the other panels here...
}

# Populate the listbox with the keys of the hashtable
$listBox.Items.AddRange($panelMap.Keys)

# Add a SelectedIndexChanged event handler to the listbox
$listBox.Add_SelectedIndexChanged({
  # Hide all panels
  foreach ($panel in $panelMap.Values) {
      $panel.Visible = $false
  }

  # Show the panel corresponding to the selected item
  $selectedItem = $listBox.SelectedItem.ToString()
  if ($panelMap.ContainsKey($selectedItem)) {
      $panelMap[$selectedItem].Visible = $true
  }
})

# Show the form
$form.ShowDialog()