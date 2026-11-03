$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0 # wdAlertsNone

$doc = $word.Documents.Add()
$doc.SaveAs2("D:\Work\android_projects\gorouter\blank_test.docx", 16)
$doc.Close()
$word.Quit()

Write-Host "Blank test docx created: $(Test-Path 'D:\Work\android_projects\gorouter\blank_test.docx')"
