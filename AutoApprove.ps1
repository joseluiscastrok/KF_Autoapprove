
# Approve , Aprovacion facturacion  INTEC
#  https://<your_account_id>.appspot.com/api/1/<process_name>/list/<process_step>/p<page_number>/<page_size>
#curl - H  "api_key:<your_api_key>" -X GET https://<your_account_id>.appspot.com/api/1/Travel Claim/list/p1/50
#curl - H  "api_key:<your_api_key>" -X GET https://<your_account_id>.appspot.com/api/1/Travel Claim/list/Manager Approval/p2/50

clear
$proceso="FacturacionV4"
$steps=@("NotificacionAsesor","AprobacionDescuento")

foreach ($step in $steps) {
echo "######################################################################"
echo $step
echo "######################################################################"

echo "Timer : $timer"

$uri1="https://kf-0001671.appspot.com/api/1/"+$proceso+"/list/"+$step+"/p1/999"

$a= Invoke-WebRequest $uri1 -headers @{api_key='3c08e754-035c-11e7-b9f9-21120311034c'}
$b = $a.content | ConvertFrom-Json

$i=0



foreach ($item in $b) {
$i

### read timer
if ($step -eq "NotificacionAsesor") {
$timer=$item.PlazoAutoaprobacionNotifAsesor 
$email="gprocesos@divemotor.com.pe"
$action="done"
$comment=""
}

if ($step -eq "AprobacionDescuento") {
$timer=$item.PlazoAutoaprobacionApDescuento
$email="gprocesos@divemotor.com.pe"
$action="reject"
$comment="Plazo de aprobacion vencido"
}


#if ($item.'Process Step' -eq "Aprobacion") {
 $item.id
 $item.'Numero_de_OT'
 $item.'Process Step'
 $item.'Action Performed DateTime'
# $item.'Process Step'
### check dates
$today = get-date
$limitdate = $item.'Action Performed DateTime' | Get-Date
$limitdate=$limitdate.AddMinutes($timer)
$limitdate=$limitdate.AddHours(-5)
echo "to UTC"
echo "Fecha Actual $today"
echo "Fecha Limite $limitdate"

#check progress
#$uri_p=" https://kf-0001671.appspot.com/api/1/Facturacion/"+$item.id+"/progress"
#$c1=Invoke-WebRequest -uri $uri_p -headers @{api_key='3c08e754-035c-11e7-b9f9-21120311034c';email_id='gprocesos@divemotor.com.pe'} -Method Get 
#$contenido= $c1.content | ConvertFrom-Json
#$contenido.steps


if ($limitdate -lt $today) { 
echo "Autoapprove!!!!!"
###POST https://<your_account_id>.appspot.com/api/1/<process_name>/<request_subject or request_id>/done
$uri=" https://kf-0001671.appspot.com/api/1/"+$proceso+"/"+$item.id+"/"+$action
$item.'Process Step'


#echo $uri
Invoke-WebRequest -uri $uri -headers @{api_key='3c08e754-035c-11e7-b9f9-21120311034c';email_id=$email} -Body @{Comment=$comment} -Method Post

}

#}
$i++
}

}
