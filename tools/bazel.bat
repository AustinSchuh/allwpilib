@echo off
setlocal enabledelayedexpansion

:: Bazelisk runs this wrapper instead of Bazel itself on Windows.  It bootstraps
:: a private copy of PortableGit, which supplies both git and bash/sh, and then
:: scrubs the environment before handing off to Bazel.  That keeps the build from
:: depending on whatever happens to be installed and on PATH on the machine.

:: Use the short (8.3) form of the profile directory so that a user name with a
:: space in it doesn't break paths downstream.
for %%I in ("%USERPROFILE%") do set "USERPROFILE=%%~sI"

set "BAZEL_CACHE_DIR=%USERPROFILE%\.cache\bazel"

:: 1. Figure out which bazel we are supposed to hand off to.
if defined BAZEL_OVERRIDE (
    echo Actually calling "%BAZEL_OVERRIDE%"
    set "_SAVE_TARGET=%BAZEL_OVERRIDE%"
) else (
    :: 2. Ensure Bazelisk integration.
    if not defined BAZEL_REAL (
        echo Error: This script must be run via Bazelisk on Windows. >&2
        exit /b 1
    )
    set "_SAVE_TARGET=%BAZEL_REAL%"
)

:: 3. Automated hermetic git bootstrapping with SHA256 validation.
set "GIT_CACHE_DIR=%BAZEL_CACHE_DIR%\portable_git"
set "GIT_EXE_PATH=%GIT_CACHE_DIR%\cmd\git.exe"

if not exist "%GIT_EXE_PATH%" (
    echo [Wrapper] Git not detected in runtime cache. Fetching isolated PortableGit... >&2

    set "GIT_VERSION=v2.44.0.windows.1"
    set "GIT_ZIP_NAME=PortableGit-2.44.0-64-bit.7z.exe"
    set "GIT_URL=https://github.com/git-for-windows/git/releases/download/!GIT_VERSION!/!GIT_ZIP_NAME!"
    set "EXPECTED_SHA256=1fc64ca91b9b475ab0ada72c9f7b3addbe69a6c8f520be31425cf21841cca369"

    set "TEMP_DOWNLOAD_DIR=%BAZEL_CACHE_DIR%\git_tmp"
    if exist "!TEMP_DOWNLOAD_DIR!" rmdir /s /q "!TEMP_DOWNLOAD_DIR!"
    mkdir "!TEMP_DOWNLOAD_DIR!"

    echo [Wrapper] Downloading from !GIT_URL! ... >&2

    curl -fL --silent --show-error --output "!TEMP_DOWNLOAD_DIR!\git.7z.exe" "!GIT_URL!"
    if errorlevel 1 (
        echo Error: Failed to download hermetic Git toolchain >&2
        exit /b 1
    )

    echo [Wrapper] Validating cryptographic payload checksum... >&2
    set "COMPUTED_SHA256="
    for /f "skip=1 delims=" %%A in ('certutil -hashfile "!TEMP_DOWNLOAD_DIR!\git.7z.exe" SHA256 ^| findstr /v "CertUtil"') do (
        set "LINE=%%A"
        set "LINE=!LINE: =!"
        set "COMPUTED_SHA256=!LINE!"
    )

    if /i not "!COMPUTED_SHA256!"=="!EXPECTED_SHA256!" (
        echo. >&2
        echo =============================================================== >&2
        echo SECURITY ERROR: Cryptographic checksum mismatch detected. >&2
        echo Expected: !EXPECTED_SHA256! >&2
        echo Received: !COMPUTED_SHA256! >&2
        echo =============================================================== >&2
        rmdir /s /q "!TEMP_DOWNLOAD_DIR!"
        exit /b 1
    )
    echo [Wrapper] Integrity verification successful. SHA256 matches. >&2

    echo [Wrapper] Extracting archive package... >&2
    mkdir "%GIT_CACHE_DIR%" 2>nul
    "!TEMP_DOWNLOAD_DIR!\git.7z.exe" -y -o"%GIT_CACHE_DIR%" >nul

    rmdir /s /q "!TEMP_DOWNLOAD_DIR!"

    echo [Wrapper] Isolated Git runtime setup completed successfully. >&2
)

:: 4. Environment sandboxing (the Windows equivalent of "env -i").
set "_SAVE_SYSTEMROOT=%SystemRoot%"
set "_SAVE_SYSTEMDRIVE=%SystemDrive%"
set "_SAVE_COMSPEC=%ComSpec%"
set "_SAVE_PATH=%PATH%"
set "_SAVE_PATHEXT=%PATHEXT%"
set "_SAVE_TEMP=%TEMP%"
set "_SAVE_TMP=%TMP%"
set "_SAVE_USERPROFILE=%USERPROFILE%"
set "_SAVE_USERNAME=%USERNAME%"
set "_SAVE_COMPUTERNAME=%COMPUTERNAME%"
set "_SAVE_PROCESSOR_ARCHITECTURE=%PROCESSOR_ARCHITECTURE%"
:: Explicit MSVC overrides are an escape hatch for machines where Visual Studio
:: isn't in the default location, so let them survive the purge.
set "_SAVE_BAZEL_VC=%BAZEL_VC%"
set "_SAVE_BAZEL_VS=%BAZEL_VS%"
set "_SAVE_BAZEL_VC_FULL_VERSION=%BAZEL_VC_FULL_VERSION%"
set "_SAVE_BAZEL_WINSDK_FULL_VERSION=%BAZEL_WINSDK_FULL_VERSION%"
:: Critical cradle: back up our bootstrapped Git path and git configuration so
:: the environment purge loop below ignores them.  Configure git through
:: GIT_CONFIG_PARAMETERS rather than "git config --global" so that we don't
:: scribble on the developer's own ~/.gitconfig.  The value has to be a list of
:: single quoted key=value pairs or git rejects it outright.
set "_SAVE_GIT_CACHE_DIR=%GIT_CACHE_DIR%"
set "_SAVE_GIT_CONFIG_PARAMETERS='http.sslBackend=openssl' 'http.sslVerify=true'"

for /f "tokens=1 delims==" %%a in ('set') do (
    set "VAR_NAME=%%a"
    if not "!VAR_NAME:~0,6!"=="_SAVE_" (
        set "%%a="
    )
)

set "SystemRoot=%_SAVE_SYSTEMROOT%"
set "SystemDrive=%_SAVE_SYSTEMDRIVE%"
set "ComSpec=%_SAVE_COMSPEC%"
set "PATHEXT=%_SAVE_PATHEXT%"
set "TEMP=%_SAVE_TEMP%"
set "TMP=%_SAVE_TMP%"
set "USERPROFILE=%_SAVE_USERPROFILE%"
set "HOME=%_SAVE_USERPROFILE%"
set "USERNAME=%_SAVE_USERNAME%"
set "USER=%_SAVE_USERNAME%"
set "COMPUTERNAME=%_SAVE_COMPUTERNAME%"
set "HOSTNAME=%_SAVE_COMPUTERNAME%"
set "PROCESSOR_ARCHITECTURE=%_SAVE_PROCESSOR_ARCHITECTURE%"
set "GIT_CONFIG_PARAMETERS=%_SAVE_GIT_CONFIG_PARAMETERS%"

if defined _SAVE_BAZEL_VC set "BAZEL_VC=%_SAVE_BAZEL_VC%"
if defined _SAVE_BAZEL_VS set "BAZEL_VS=%_SAVE_BAZEL_VS%"
if defined _SAVE_BAZEL_VC_FULL_VERSION set "BAZEL_VC_FULL_VERSION=%_SAVE_BAZEL_VC_FULL_VERSION%"
if defined _SAVE_BAZEL_WINSDK_FULL_VERSION set "BAZEL_WINSDK_FULL_VERSION=%_SAVE_BAZEL_WINSDK_FULL_VERSION%"

set "PATH=%_SAVE_SYSTEMROOT%\system32;%_SAVE_SYSTEMROOT%;%_SAVE_SYSTEMROOT%\System32\Wbem;%_SAVE_GIT_CACHE_DIR%\cmd;%_SAVE_GIT_CACHE_DIR%\bin;%_SAVE_GIT_CACHE_DIR%\usr\bin;%_SAVE_PATH%"

:: Critical explicit binding: force Bazel's repository rules to bypass PATH
:: lookups entirely and use the copies we just bootstrapped.
set "BAZEL_GIT=%_SAVE_GIT_CACHE_DIR%\cmd\git.exe"
set "GIT_BIN_PATH=%_SAVE_GIT_CACHE_DIR%\cmd\git.exe"
set "BAZEL_SH=%_SAVE_GIT_CACHE_DIR%\bin\bash.exe"

set "TERM=dumb"
set "LANG=C"
set "BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=0"

:: 5. Drop the scratch copies so that they do not leak into the environment
:: that Bazel and its repository rules end up seeing.
set "VAR_NAME="
for /f "tokens=1 delims==" %%a in ('set _SAVE_') do (
    if not "%%a"=="_SAVE_TARGET" set "%%a="
)

:: 6. Execute the isolated Bazel process.
"%_SAVE_TARGET%" %*
endlocal
