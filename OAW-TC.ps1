function fn_redirec ($extensiones, $file)
{
    foreach($extension in $extensiones){
        if($extension -match '^woff2[a-zA-Z_0-9]+'){
            $file = $file -replace [regex]::escape($extension), 'woff2'
        }

        elseif($extension -match '^woff[^2][a-zA-Z_0-9]{2}'){
            $file = $file -replace [regex]::escape($extension), 'woff'
        }
        
        elseif($extension -match '^eot[a-zA-Z_0-9]{2}'){
            $file = $file -replace [regex]::escape($extension), 'eot'
        }
        
        elseif($extension -match '^ttf[a-zA-Z_0-9]{2}'){
            $file = $file -replace [regex]::escape($extension), 'ttf'
        }
        
        elseif($extension -match '^svg[a-zA-Z_0-9]{2}'){
            $file = $file -replace [regex]::escape($extension), 'svg'
        }
        
        elseif($extension -match '^gif[a-zA-Z_0-9]{2}'){
            $file = $file -replace [regex]::escape($extension), 'gif'
        }
        
        elseif($extension -match '^png[a-zA-Z_0-9]{2}'){
            $file = $file -replace [regex]::escape($extension), 'png'
        }
        
        elseif($extension -match '^jpg[a-zA-Z_0-9]{2}'){
            $file = $file -replace [regex]::escape($extension), 'jpg'
        }
        
        elseif($extension -match '^css[a-zA-Z_0-9]{2}'){
            $file = $file -replace [regex]::escape($extension), 'css'
        }
        
        elseif($extension -match '^js[a-zA-Z_0-9]{2}'){
            $file = $file -replace [regex]::escape($extension), 'js'
        }
    }
    return $file
}
#$error = ""
$template = Read-Host "Ingresa la carperta de su Tempalte-PF"
clear
$template = $template.Replace('"','')
if (Test-Path "$template\resources"){
    Write-Host -ForegroundColor Green '¡Al parecer su plantilla ya esta limpia!.'
    Write-Host -ForegroundColor Red 'Si no es así, elimine la carpeta "resources".'
    Write-Host -ForegroundColor Blue 'dirigase aqui para más información ->'
    pause
    exit
}

if (Test-Path "$template\javax.faces.resource"){
    Rename-Item -Path "$template\javax.faces.resource" -NewName 'resources' -Force
}

if (Test-Path "$template\resources\fa\*.html"){
    Remove-Item -Path "$template\resources\fa\*.html" -Force
}

$archivos = Get-ChildItem -Path $template -Recurse
$archivos | ForEach-Object -Begin {$progreso = 0} -Process {
    Write-Progress -Activity "Renombrando/Eliminando archivos..." -Status ($progreso.ToString() + "/" + $archivos.Length.ToString()) -PercentComplete ($progreso/$archivos.Length*100)
    $progreso = $progreso+1
    if($_.BaseName -match 'jsessionid'){
        Remove-Item -Path $_.FullName
    }
    
    elseif($_.BaseName -match '\.'){
        if($_.BaseName -match '\.woff2'){
            $name = $_.BaseName -replace '\.', '.+' -split '\.',2 -notmatch '\+'
            Rename-Item -Path $_.FullName -NewName "$name.woff2"
        }

        elseif($_.BaseName -match '\.woff'){
            $name = $_.BaseName -replace '\.', '.+' -split '\.',2 -notmatch '\+'
            Rename-Item -Path $_.FullName -NewName "$name.woff"
        }

        elseif($_.BaseName -match '\.eot'){
            $name = $_.BaseName -replace '\.', '.+' -split '\.',2 -notmatch '\+'
            Rename-Item -Path $_.FullName -NewName "$name.eot" -ErrorAction silentlycontinue
        }

        elseif($_.BaseName -match '\.ttf'){
            $name = $_.BaseName -replace '\.', '.+' -split '\.',2 -notmatch '\+'
            Rename-Item -Path $_.FullName -NewName "$name.ttf"
        }

        elseif($_.BaseName -match '\.svg'){
            $name = $_.BaseName -replace '\.', '.+' -split '\.',2 -notmatch '\+'
            Rename-Item -Path $_.FullName -NewName "$name.svg"
        }

        elseif($_.BaseName -match '\.gif'){
            $name = $_.BaseName -replace '\.', '.+' -split '\.',2 -notmatch '\+'
            Rename-Item -Path $_.FullName -NewName "$name.gif"
        }

        elseif($_.BaseName -match '\.png'){
            $name = $_.BaseName -replace '\.', '.+' -split '\.',2 -notmatch '\+'
            Rename-Item -Path $_.FullName -NewName "$name.png"
        }

        elseif($_.BaseName -match '\.jpg'){
            $name = $_.BaseName -replace '\.', '.+' -split '\.',2 -notmatch '\+'
            Rename-Item -Path $_.FullName -NewName "$name.jpg"
        }

        elseif($_.BaseName -match '\.css'){
            $name = $_.BaseName -replace '\.', '.+' -split '\.',2 -notmatch '\+'
            Rename-Item -Path $_.FullName -NewName "$name.css"
        }

        elseif($_.BaseName -match '\.js'){
            $name = $_.BaseName -replace '\.', '.+' -split '\.',2 -notmatch '\+'
            Rename-Item -Path $_.FullName -NewName "$name.js"
        }
    }
}

$archivos = Get-ChildItem -Path $template -Recurse
$archivos | ForEach-Object -Begin {$progreso = 0} -Process {
    Write-Progress -Activity "Redireccionando..." -Status ($progreso.ToString() + "/" + $archivos.Length.ToString()) -PercentComplete ($progreso/$archivos.Length*100)
    $progreso = $progreso+1
    if ($_.Extension.Equals('.css') -or $_.Extension.Equals('.html'))
    {
        $file = Get-Content $_.FullName -Encoding UTF8
        $file = $file -replace 'javax.faces.resource','#{request.contextPath}/faces/resources'
        $extensiones = $file -replace '"','"+' -split '"' -match "\+" -split '/' -split '\.',2  | select -Unique
        $file = fn_redirec -file $file -extensiones $extensiones
        Remove-Item -Path $_.FullName -Force
        $file | Out-File $_.FullName -Encoding utf8
    }
}
Write-Host -ForegroundColor Green "¡Su template se limpió correctamente!"
pause