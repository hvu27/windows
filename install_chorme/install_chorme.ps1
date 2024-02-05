# Khởi tạo biến
$Path = $env:TEMP
$Installer = 'chrome_installer.exe'
$Uri = 'http://dl.google.com/chrome/install/375.126/chrome_installer.exe'

# Tải xuống với hiển thị tiến trình
$webClient = New-Object System.Net.WebClient
Register-ObjectEvent -InputObject $webClient -EventName DownloadFileCompleted -Action {
    Write-Progress -Activity "Đang tải xuống Google Chrome" -Completed
    Write-Host "Tải xuống thành công!"
    Unregister-Event -SourceIdentifier $eventSubscriber.Name
}

# Bắt đầu tải xuống
$webClient.DownloadFileAsync((New-Object System.Uri($Uri)), "$Path\$Installer")

# Chờ cho đến khi tải xuống hoàn tất
while ($webClient.IsBusy) { Start-Sleep -Seconds 1 }

# Giả lập tiến trình cài đặt
Write-Host "Bắt đầu cài đặt..."
for ($i = 0; $i -le 100; $i += 10) {
    Write-Progress -Activity "Đang cài đặt Google Chrome" -Status "$i%" -PercentComplete $i
    Start-Sleep -Seconds 1 # Giả định mỗi bước cài đặt mất 1 giây
}

# Thực hiện cài đặt
Start-Process -FilePath "$Path\$Installer" -Args '/silent /install' -Verb RunAs -Wait

# Thông báo hoàn tất cài đặt
Write-Progress -Activity "Đang cài đặt Google Chrome" -Completed
Write-Host "Cài đặt Google Chrome hoàn tất!"

# Xóa bộ cài đặt
Remove-Item -Path "$Path\$Installer"