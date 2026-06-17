Add-Type -AssemblyName System.Drawing

$srcPath = 'C:\New\bioparque_pantanal\assets\src\icones_original.png'
$outDir = 'C:\New\bioparque_pantanal\assets\classes'
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$names = @('mamifero','reptil','anfibio','peixe','ave','invertebrado')

$src = New-Object System.Drawing.Bitmap $srcPath
$W = $src.Width
$H = $src.Height
$colW = $W / 6
# Icone fica na parte superior (cerca de 65% da altura, excluindo o rotulo)
$iconH = [int]($H * 0.55)

for ($i = 0; $i -lt 6; $i++) {
    $x0 = [int]($i * $colW)
    $x1 = [int](($i + 1) * $colW)
    $w = $x1 - $x0
    $h = $iconH

    # Cropa coluna completa para um bitmap RGBA
    $crop = New-Object System.Drawing.Bitmap $w, $h, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($crop)
    $g.DrawImage($src,
        (New-Object System.Drawing.Rectangle 0, 0, $w, $h),
        (New-Object System.Drawing.Rectangle $x0, 0, $w, $h),
        [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()

    # Remove fundo cremoso: pixels com R+G+B muito alto e proximos a cor creme viram alpha 0
    $rect = New-Object System.Drawing.Rectangle 0, 0, $w, $h
    $data = $crop.LockBits($rect,
        [System.Drawing.Imaging.ImageLockMode]::ReadWrite,
        [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $bytes = New-Object Byte[] ($data.Stride * $h)
    [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)

    $minX = $w; $minY = $h; $maxX = 0; $maxY = 0

    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $idx = $y * $data.Stride + $x * 4
            $b = $bytes[$idx]
            $g2 = $bytes[$idx + 1]
            $r = $bytes[$idx + 2]
            # Cor creme aproximada (250,246,236). Tolerancia: pixels com R,G,B >= 220 viram transparente.
            if ($r -ge 215 -and $g2 -ge 210 -and $b -ge 195) {
                $bytes[$idx + 3] = 0
            } else {
                # Mantem alpha e atualiza bounding box
                if ($x -lt $minX) { $minX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }

    [System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $data.Scan0, $bytes.Length)
    $crop.UnlockBits($data)

    # Pad em volta do bounding box
    $pad = 12
    $bx = [Math]::Max(0, $minX - $pad)
    $by = [Math]::Max(0, $minY - $pad)
    $bw = [Math]::Min($w - $bx, $maxX - $minX + 2 * $pad)
    $bh = [Math]::Min($h - $by, $maxY - $minY + 2 * $pad)

    $cropped = New-Object System.Drawing.Bitmap $bw, $bh, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g3 = [System.Drawing.Graphics]::FromImage($cropped)
    $g3.DrawImage($crop,
        (New-Object System.Drawing.Rectangle 0, 0, $bw, $bh),
        (New-Object System.Drawing.Rectangle $bx, $by, $bw, $bh),
        [System.Drawing.GraphicsUnit]::Pixel)
    $g3.Dispose()

    $outPath = Join-Path $outDir ($names[$i] + '.png')
    $cropped.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "$($names[$i]).png  -> $($bw)x$($bh)"

    $cropped.Dispose()
    $crop.Dispose()
}

$src.Dispose()
Write-Host "Done."
