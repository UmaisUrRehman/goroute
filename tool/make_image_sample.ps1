$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

$doc = $word.Documents.Add()
$sel = $word.Selection
$shp = $sel.InlineShapes.AddPicture("D:\Work\android_projects\gorouter\screenshots\01_home_screen_light.png")
$doc.SaveAs2("D:\Work\android_projects\gorouter\sample_with_image.docx", 16)
$doc.Close()
$word.Quit()

Write-Host "Created sample_with_image.docx"
