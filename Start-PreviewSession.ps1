﻿Param(
    [string]$cmsUrl = "http://localhost:81",
    [string]$pageId = "tcm:5-224-64",  # TODO: support WebDAV URL
    [string]$pageTemplateId = "tcm:5-182-128",  # TODO: determine from Page (using Core Service)
    [string]$publishingTargetId = "tcm:0-2-65538"  # TODO: Support Purpose (lookup Target Type using Core Service)
)


$getPreviewTokenUrl = "$cmsUrl/WebUI/Models/SiteEdit/Services/SessionPreviewService.svc/GetPreviewToken"

$getPreviewTokenHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$getPreviewTokenHeaders.Add("X-SDL-Tridion-Token", '666') # TODO: This should be a genuine token, but this works too (for now)

$publishedItemInfo = @{
    ItemId = $pageId
    TemplateId = $pageTemplateId
    ItemLastModifiedTimeStamp = "/Date(1000000000000)/"  # Intentionally using a date in the past, to ensure it is resolved/rendered
    ComponentPresentationType = 0
    }

$getPreviewTokenBody = @{
    publishedItemsInfo = @($publishedItemInfo)
    publishingTargetId = $publishingTargetId
    }

$getPreviewTokenJson = $getPreviewTokenBody | ConvertTo-Json

$getPreventTokenResponse = Invoke-RestMethod `
    -Uri $getPreviewTokenUrl `
    -Method Post `
    -ContentType "application/json" `
    -Headers $getPreviewTokenHeaders `
    -Body $getPreviewTokenJson `
    -UseDefaultCredentials 

# Write-Host "Preview Token:"
$getPreventTokenResponse.d