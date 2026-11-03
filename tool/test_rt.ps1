$word = New-Object -ComObject Word.Application
$word.Visible = $false
try {
    $doc = $word.Documents.Open("D:\Work\android_projects\gorouter\test_roundtrip.docx")
    Write-Host "test_roundtrip.docx opened successfully!"
    $doc.Close()
} catch {
    Write-Host "test_roundtrip failed: $($_.Exception.Message)"
} finally {
    $word.Quit()
}
