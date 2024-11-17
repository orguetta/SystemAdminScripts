$sourcePath = "C:\Temp\Test\OUT"
$destPath = "C:\Temp\Test\In"
$FileExt1 = "*.xxx"
$FileExt2 = "*.xxx"
Write-Host "Moving all files in '$($sourcePath)' to '$($destPath)'"
$fileList1 = @(Get-ChildItem -Path "$($sourcePath)" -File -Recurse -Include $FileExt1)
$fileList2 = @(Get-ChildItem -Path "$($sourcePath)" -File -Recurse -Include $FileExt2)
$directoryList = @(Get-ChildItem -Path "$($sourcePath)" -Directory -Recurse)
ForEach($directory in $directoryList){
New-Item ($directory.FullName).Replace("$($sourcePath)",$destPath) -ItemType Directory -ea SilentlyContinue | Out-Null
}
ForEach($file in $fileList1){
try {
Move-Item -Path $file.FullName -Destination ((Split-Path $file.FullName).Replace("$($sourcePath)",$destPath)) -Force -ErrorAction Stop
}
catch{
Write-Warning "Unable to move '$($file.FullName)' to '$(((Split-Path $file.FullName).Replace("$($sourcePath)",$destPath)))': $($_)"
return
}
}
ForEach($file in $fileList2){
    try {
    Move-Item -Path $file.FullName -Destination ((Split-Path $file.FullName).Replace("$($sourcePath)",$destPath)) -Force -ErrorAction Stop
    }
    catch{
    Write-Warning "Unable to move '$($file.FullName)' to '$(((Split-Path $file.FullName).Replace("$($sourcePath)",$destPath)))': $($_)"
    return
    }
    }
#Write-Host "Deleting folder '$($sourcePath)'"
#Remove-Item -Path "$($sourcePath)" -Recurse -Force -ErrorAction Stop