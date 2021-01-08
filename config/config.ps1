$Date = get-date -Format "MM.dd.yyyy"
$Day = get-date -UFormat %A

# 0 for automatic
# 1 for manual
$ServerList = 0
 
# Set to true or false for server types you want to run on.
# See readme for details on compatibility
# Change ServerIdentifier to how you distinguish servers on your network.
# For Example, my network is layed out SiteCode-ServerIdentifier-ServerNumber (ABCD-DC-001V)
$ServerOptions = @{
    DC = @{
        LongName = "Domain Controller"
        ServerIdentifier = "*-dc-*"
        Enabled = $false
    }
    DRA = @{
        LongName = "NetIQ Directory and Resource Administrator"
        ServerIdentifier = "*-ra-*"
        Enabled = $false
    }
    DHCP = @{
        LongName = "Dynamic Host Configuration Protocol"
        ServerIdentifier = "*-hc-*"
        Enabled = $true
    }
}


# Multithreading settings
$MaxThreads = 20
$SleepTimer = 500
$MaxWaitAtEnd = 600

# PowerWeb Settings
$Port = 8080