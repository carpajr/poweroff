# -----------------------------------------------------------------------------+
# Simplified POWEROFF

$urlCmd = "http://domain/infra/poweroff/lab/index.htm"
$action = "on"
 
# Verificando servidor
try{
	$action = retrieveHttpData($urlCmd).ToString()
	$action = [string]$action
}
catch{
	# Do something :)
}
 
if ($action.Contains("off")){
	shutdown /s /t 100  
}

exit
