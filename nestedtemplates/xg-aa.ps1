Param
(
  [Parameter (Mandatory= $true)]
  [SecureString] $password,
  [Parameter (Mandatory= $true)]
  [String] $portaip,
  [Parameter (Mandatory= $true)]
  [String] $portagw,
  [Parameter (Mandatory= $true)]
  [String] $hostname,
  [Parameter (Mandatory= $true)]
  [String] $sshport
)
$secpassword = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ("admin", $secpassword)
$session = New-SSHSession -ComputerName $hostname -Credential $creds -AcceptKey -Port $sshport
$SSHStream = New-SSHShellStream -SessionId $session.SessionId
If ($session.Connected) {
    Start-Sleep -s 10
	$SSHStream.WriteLine("a")
	Start-Sleep -s 5
	$SSHStream.WriteLine(" ")
	$SSHStream.WriteLine(" ")
	Start-Sleep -s 5
	$SSHStream.WriteLine("5")
    Start-Sleep -s 5
    $SSHStream.WriteLine("3")
    Start-Sleep -s 5
    $SSHStream.WriteLine("mount -o remount,rw /")
    Start-Sleep -s 5
    $SSHStream.WriteLine("echo '200 azurespecialroutes' >> /etc/iproute2/rt_tables")
    Start-Sleep -s 5
	$SSHStream.WriteLine("sed -i `"2i ip route add default via $portagw dev PortA table 200`" /scripts/system/clientpref/customization_application_startup.sh")
    Start-Sleep -s 5
    $SSHStream.WriteLine("sed -i `"3i ip rule add from $portaip to 168.63.129.16 table 200`" /scripts/system/clientpref/customization_application_startup.sh")
    Start-Sleep -s 5
	$SSHStream.WriteLine("sed -i `"4i ip route flush cache`" /scripts/system/clientpref/customization_application_startup.sh")
	Start-Sleep -s 5
	$SSHStream.WriteLine("reboot")
    Start-Sleep -s 5
    $SSHStream.Read()  
    Remove-SSHSession -SessionId $session.SessionId > $null
}
Else {
    "Could not connect to XG"
    Get-SSHSession | Remove-SSHSession > $null
}