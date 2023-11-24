# Defines a C# class 'DarkTitleBar' to enable immersive dark mode for a window, affecting the title bar color.
# The 'UseImmersiveDarkMode' method enables/disables dark mode based on the window handle and a boolean input.
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class DarkTitleBar {
    [DllImport("dwmapi.dll")]
    private static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int attrValue, int attrSize);

    private const int DWMWA_USE_IMMERSIVE_DARK_MODE_BEFORE_20H1 = 19;
    private const int DWMWA_USE_IMMERSIVE_DARK_MODE = 20;

    public static bool UseImmersiveDarkMode(IntPtr handle, bool enabled) {
        if (IsWindows10OrGreater(17763)) {
            var attribute = DWMWA_USE_IMMERSIVE_DARK_MODE_BEFORE_20H1;
            if (IsWindows10OrGreater(18985)) {
                attribute = DWMWA_USE_IMMERSIVE_DARK_MODE;
            }

            int useImmersiveDarkMode = enabled ? 1 : 0;
            return DwmSetWindowAttribute(handle, attribute, ref useImmersiveDarkMode, sizeof(int)) == 0;
        }

        return false;
    }

    private static bool IsWindows10OrGreater(int build = -1) {
        return Environment.OSVersion.Version.Major >= 10 && Environment.OSVersion.Version.Build >= build;
    }
}
"@

# Defines a C# class 'DpiAwareness' to set the DPI awareness of the current process.
# The 'SetDpiAwareness' method calls the 'SetProcessDPIAware' function from user32.dll to make the process DPI-aware.
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

# Use the 'DpiAwareness' class to make the process DPI-aware
[DpiAwareness]::SetDpiAwareness()

# Loads the Windows Forms assembly and enables visual styles
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Creates the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Daily Admin"
$form.Size = New-Object System.Drawing.Size(900, 600)
$form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#1E1E1E") # Dark gray background
$form.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF") # White text
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# Use the DarkTitleBar class to enable the immersive dark mode for the main form
[DarkTitleBar]::UseImmersiveDarkMode($form.Handle, $true)

# Create a sidebar listbox 200px wide and as tall as the form
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(0,0)
$listBox.Width = 200
$listBox.Dock = 'Left'
$listBox.SelectionMode = 'One'
$listBox.BorderStyle = 'None'
$listBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#252526") # Darker gray background for the sidebar
$listBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF") # White text
$listBox.Font = New-Object System.Drawing.Font("Segoe UI", 14)
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

# Create a hashtable to map listbox items to panels
$panelMap = @{
  'Reset & Unlock' = $ResetUnlock
  'Create Account' = $panel2
  # Add the other panels here...
}

# Manually add the items to the ListBox in the order you want
$listBox.Items.Add('Reset & Unlock')
$listBox.Items.Add('Create Account')

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