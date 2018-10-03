# Set-ADPhotos.ps1
# Description: For each file in a given directory it searches AD for a matching username. When it finds a match it updates
#     the jpegPhoto and thumbnailPhoto attributes for the account with the jpg file
# Credit for ResizeImage Function goes to Lewis Roberts
# http://www.lewisroberts.com/2015/01/18/powershell-image-resize-function/
#
# USAGE: .\Set-ADPhotos.ps1 -jpgdir "c:\photos" -OU "LDAP://ou=staff,dc=foo,dc=com"

param (
    [string]$jpgdir,
    [string]$OU
)

Import-Module ActiveDirectory

#$objOU = New-Object System.DirectoryServices.DirectoryEntry($OU)

Function ResizeImage() {
    param([String]$ImagePath, [Int]$Quality = 90, [Int]$targetSize, [String]$OutputLocation)

    Add-Type -AssemblyName "System.Drawing"

    $img = [System.Drawing.Image]::FromFile($ImagePath)

    $CanvasWidth = $targetSize
    $CanvasHeight = $targetSize

    #Encoder parameter for image quality
    $ImageEncoder = [System.Drawing.Imaging.Encoder]::Quality
    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($ImageEncoder, $Quality)

    # get codec
    $Codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where {$_.MimeType -eq 'image/jpeg'}

    #compute the final ratio to use
    $ratioX = $CanvasWidth / $img.Width;
    $ratioY = $CanvasHeight / $img.Height;

    $ratio = $ratioY
    if ($ratioX -le $ratioY) {
        $ratio = $ratioX
    }

    $newWidth = [int] ($img.Width * $ratio)
    $newHeight = [int] ($img.Height * $ratio)

    $bmpResized = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
    $graph = [System.Drawing.Graphics]::FromImage($bmpResized)
    $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    $graph.Clear([System.Drawing.Color]::White)
    $graph.DrawImage($img, 0, 0, $newWidth, $newHeight)

    #save to file
    $bmpResized.Save($OutputLocation, $Codec, $($encoderParams))
    $bmpResized.Dispose()
    $img.Dispose()
}

foreach ($photo in (Get-ChildItem -Path $jpgdir -File)) {    
    $username = $photo.BaseName
    $resizefile = $jpgdir + "\resized\" + $photo.BaseName + ".jpg"
    
    Try{$sADUser = Get-ADUser $username -ErrorAction Stop}
        Catch {
            Write-Host ("$username not found") -ForegroundColor Red
            Continue
        }
      
    ResizeImage $photo.FullName 90 200 $resizefile

    $image = [Byte[]](Get-Content $resizefile -Encoding byte)
     
    Set-ADUser $username -Replace @{thumbnailPhoto=$image}
    Set-ADUser $username -Replace @{jpegPhoto=$image}
    Write-Host ("$username has been updated") -ForegroundColor Green    
}
