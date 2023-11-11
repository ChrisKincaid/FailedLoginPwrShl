# Define the time interval for checking the event log (in seconds)
$intervalInSeconds = 1

# Infinite loop to continuously check for failed logins
while ($true) {
    # Get the latest failed login events from the Security event log
    $failedLogins = Get-WinEvent -FilterHashtable @{
        LogName = 'Security'
        Id = 4625  # Event ID for failed logins
    } -MaxEvents 10  # Change this number to retrieve more or fewer events

    # Display information about failed logins
    foreach ($event in $failedLogins) {
        #$timeGenerated = $event.TimeGenerated # Time is not working
        $message = $event.Message

        # Extract relevant information from the event message 
        #(line11 Account Name, line15 Source Network Address, line 25 Failed Reason)      
        $line11 = $message -split "`r`n" | Select-Object -Index 12
        $line15 = $message -split "`r`n" | Select-Object -Index 16
        $line25 = $message -split "`r`n" | Select-Object -Index 26

        # Display the extracted Data
        Write-Host "Failed Login: $line11 | $line25 | $line15"
    }

    # Wait for the specified interval before checking again
    Start-Sleep -Seconds $intervalInSeconds
}