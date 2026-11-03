$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

$doc = $word.Documents.Add()
$doc.Range().Text = "Hello World"
$doc.SaveAs2("D:\Work\android_projects\gorouter\sample_valid.docx", 16)
$doc.Close()
$word.Quit()
Write-Host "Created sample_valid.docx"
