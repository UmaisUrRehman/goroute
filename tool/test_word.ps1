try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    Write-Host "Word application created successfully."
    $doc = $word.Documents.Open("D:\Work\android_projects\gorouter\TECHNICAL_REPORT.docx")
    Write-Host "DOCX opened successfully without errors!"
    $doc.Close()
} catch {
    Write-Host "Failed to open DOCX: $($_.Exception.Message)"
} finally {
    if ($word) { $word.Quit() }
}
