# Deploy helper — monta payload JSON para cada Edge Function do Poupix.
param(
  [Parameter(Mandatory = $true)]
  [string]$FunctionName
)

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$functionsRoot = Join-Path $root "supabase\functions"

$sharedFiles = @(
  "_shared\cors.ts",
  "_shared\response.ts",
  "_shared\supabase.ts",
  "_shared\otp.ts",
  "_shared\email.ts"
)

$functionFile = Join-Path $functionsRoot "$FunctionName\index.ts"
if (-not (Test-Path $functionFile)) {
  throw "Function not found: $FunctionName"
}

$files = @()
$files += @{
  name = "$FunctionName/index.ts"
  content = Get-Content $functionFile -Raw
}

foreach ($shared in $sharedFiles) {
  $path = Join-Path $functionsRoot $shared
  if (Test-Path $path) {
    $files += @{
      name = ($shared -replace '\\', '/')
      content = Get-Content $path -Raw
    }
  }
}

@{
  name = $FunctionName
  entrypoint_path = "$FunctionName/index.ts"
  verify_jwt = $false
  files = $files
} | ConvertTo-Json -Depth 5 -Compress
