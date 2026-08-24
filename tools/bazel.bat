@echo off
:: Delayed expansion stays off for the whole script, explicitly rather than by
:: inheritance, so that a "!" in an environment value or in a forwarded Bazel
:: argument -- a proxy password or a remote cache header, say -- is never eaten
:: while a line is reparsed.  Nothing below may use "!var!".
setlocal disabledelayedexpansion

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
    rem Ensure Bazelisk integration.
    if not defined BAZEL_REAL (
        echo Error: This script must be run via Bazelisk on Windows. >&2
        exit /b 1
    )
    set "_SAVE_TARGET=%BAZEL_REAL%"
)

:: 2. The pinned hermetic git.
set "GIT_RELEASE_TAG=v2.44.0.windows.1"
set "GIT_ARCHIVE_NAME=PortableGit-2.44.0-64-bit.7z.exe"
set "GIT_EXPECTED_SHA256=1fc64ca91b9b475ab0ada72c9f7b3addbe69a6c8f520be31425cf21841cca369"

:: Key the cache by the whole pin, tag and checksum both, so that any change to
:: the three lines above installs the new release instead of being short
:: circuited by a git.exe that an older revision of this script left behind.
set "GIT_CACHE_DIR=%BAZEL_CACHE_DIR%\portable_git\%GIT_RELEASE_TAG%-%GIT_EXPECTED_SHA256:~0,12%"
set "GIT_EXE_PATH=%GIT_CACHE_DIR%\cmd\git.exe"

if exist "%GIT_EXE_PATH%" goto git_ready
call :install_git
if errorlevel 1 exit /b 1
:git_ready

:: 3. Environment sandboxing (the Windows equivalent of "env -i").
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
:: rules_cc looks for vswhere.exe under %ProgramFiles(x86)% to discover the
:: MSVC install.  It falls back to the standard C: paths when the variable is
:: unset, so this only matters when Windows or Visual Studio isn't on the
:: default drive, but there is nothing to gain from dropping them.
set "_SAVE_PROGRAMFILES=%ProgramFiles%"
set "_SAVE_PROGRAMFILES_X86=%ProgramFiles(x86)%"
set "_SAVE_PROGRAMW6432=%ProgramW6432%"
set "_SAVE_PROGRAMDATA=%ProgramData%"
:: publishing_rule.bzl reads WPI_PUBLISH_CLASSIFIER_FILTER out of the
:: environment, and README-Bazel.md documents it as a knob, so keep it.
set "_SAVE_WPI_PUBLISH_CLASSIFIER_FILTER=%WPI_PUBLISH_CLASSIFIER_FILTER%"
:: Neither Bazel nor git can fetch anything from behind a proxy without these.
set "_SAVE_HTTP_PROXY=%HTTP_PROXY%"
set "_SAVE_HTTPS_PROXY=%HTTPS_PROXY%"
set "_SAVE_NO_PROXY=%NO_PROXY%"
:: Critical cradle: back up our bootstrapped Git path so the environment purge
:: loop below ignores it.
set "_SAVE_GIT_CACHE_DIR=%GIT_CACHE_DIR%"

for /f "tokens=1 delims==" %%a in ('set') do call :clear_unless_saved "%%a"
:: The subroutine creates this after the snapshot the loop iterates over,
:: so it has to be cleared by hand.
set "VAR_NAME="

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

if defined _SAVE_BAZEL_VC set "BAZEL_VC=%_SAVE_BAZEL_VC%"
if defined _SAVE_BAZEL_VS set "BAZEL_VS=%_SAVE_BAZEL_VS%"
if defined _SAVE_BAZEL_VC_FULL_VERSION set "BAZEL_VC_FULL_VERSION=%_SAVE_BAZEL_VC_FULL_VERSION%"
if defined _SAVE_BAZEL_WINSDK_FULL_VERSION set "BAZEL_WINSDK_FULL_VERSION=%_SAVE_BAZEL_WINSDK_FULL_VERSION%"
if defined _SAVE_PROGRAMFILES set "ProgramFiles=%_SAVE_PROGRAMFILES%"
if defined _SAVE_PROGRAMFILES_X86 set "ProgramFiles(x86)=%_SAVE_PROGRAMFILES_X86%"
if defined _SAVE_PROGRAMW6432 set "ProgramW6432=%_SAVE_PROGRAMW6432%"
if defined _SAVE_PROGRAMDATA set "ProgramData=%_SAVE_PROGRAMDATA%"
if defined _SAVE_WPI_PUBLISH_CLASSIFIER_FILTER set "WPI_PUBLISH_CLASSIFIER_FILTER=%_SAVE_WPI_PUBLISH_CLASSIFIER_FILTER%"
if defined _SAVE_HTTP_PROXY set "HTTP_PROXY=%_SAVE_HTTP_PROXY%"
if defined _SAVE_HTTPS_PROXY set "HTTPS_PROXY=%_SAVE_HTTPS_PROXY%"
if defined _SAVE_NO_PROXY set "NO_PROXY=%_SAVE_NO_PROXY%"

:: The original PATH is deliberately kept, but only as a low priority tail.
:: git and bash are bound by absolute path below, and --incompatible_strict_action_env
:: means Bazel hands actions a fixed PATH of its own regardless, so what is left
:: here is what repository rules see when they shell out to something this
:: wrapper hasn't pinned.  Dropping it outright breaks anyone who keeps a needed
:: tool outside the system directories, so it stays until every such lookup is
:: pinned explicitly.
set "PATH=%_SAVE_SYSTEMROOT%\system32;%_SAVE_SYSTEMROOT%;%_SAVE_SYSTEMROOT%\System32\Wbem;%_SAVE_GIT_CACHE_DIR%\cmd;%_SAVE_GIT_CACHE_DIR%\bin;%_SAVE_GIT_CACHE_DIR%\usr\bin;%_SAVE_PATH%"

:: Critical explicit binding: force Bazel's repository rules to bypass PATH
:: lookups entirely and use the copies we just bootstrapped.
set "BAZEL_GIT=%_SAVE_GIT_CACHE_DIR%\cmd\git.exe"
set "GIT_BIN_PATH=%_SAVE_GIT_CACHE_DIR%\cmd\git.exe"
set "BAZEL_SH=%_SAVE_GIT_CACHE_DIR%\bin\bash.exe"

:: HOME has to keep pointing at the real profile because Bazel reads the user
:: .bazelrc from there.  That would also hand the pinned git the developer's
:: ~/.gitconfig, where settings like core.autocrlf or url.*.insteadOf would make
:: fetches machine dependent, so point git at nonexistent config files instead.
:: Nothing in this repository is fetched over git, so there is no credential
:: helper to lose.
set "GIT_CONFIG_GLOBAL=/dev/null"
set "GIT_CONFIG_SYSTEM=/dev/null"
:: Git only accepts a list of single quoted key=value pairs here.
set "GIT_CONFIG_PARAMETERS='http.sslBackend=openssl' 'http.sslVerify=true'"

set "TERM=dumb"
set "LANG=C"
set "BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=0"

:: 4. Drop the scratch copies so that they do not leak into the environment
:: that Bazel and its repository rules end up seeing.
for /f "tokens=1 delims==" %%a in ('set _SAVE_') do (
    if not "%%a"=="_SAVE_TARGET" set "%%a="
)

:: 5. Execute the isolated Bazel process.
"%_SAVE_TARGET%" %*
exit /b %ERRORLEVEL%

:: Clear one environment variable unless it is one of the values stashed above.
:: This is a subroutine rather than the body of the loop because reading a
:: variable that was assigned in the same block would require delayed expansion.
:clear_unless_saved
set "VAR_NAME=%~1"
if /i "%VAR_NAME:~0,6%"=="_SAVE_" exit /b 0
set "%VAR_NAME%="
exit /b 0

:: Strip the spaces certutil pads its digest with.  Also a subroutine so that
:: the value never passes through delayed expansion.
:set_computed_sha256
set "SHA_LINE=%~1"
set "COMPUTED_SHA256=%SHA_LINE: =%"
exit /b 0

:: Fetch, verify, and install the pinned PortableGit release.
::
:: Everything happens in a staging directory private to this process and is
:: published with a single rename, so that two Bazelisk invocations racing on a
:: cold cache can't corrupt each other's download and a failed install never
:: leaves a half unpacked tree behind for the next invocation to trust.
:install_git
echo [Wrapper] Git %GIT_RELEASE_TAG% is not in the runtime cache. Fetching isolated PortableGit... >&2

set "STAGE_DIR=%BAZEL_CACHE_DIR%\portable_git\staging_%RANDOM%_%RANDOM%"
if exist "%STAGE_DIR%" rmdir /s /q "%STAGE_DIR%"
mkdir "%STAGE_DIR%" 2>nul
if not exist "%STAGE_DIR%" (
    echo Error: Unable to create the staging directory %STAGE_DIR% >&2
    exit /b 1
)

set "GIT_URL=https://github.com/git-for-windows/git/releases/download/%GIT_RELEASE_TAG%/%GIT_ARCHIVE_NAME%"
echo [Wrapper] Downloading from %GIT_URL% ... >&2

curl -fL --silent --show-error --output "%STAGE_DIR%\git.7z.exe" "%GIT_URL%"
if errorlevel 1 (
    echo Error: Failed to download the hermetic Git toolchain >&2
    rmdir /s /q "%STAGE_DIR%"
    exit /b 1
)

echo [Wrapper] Validating cryptographic payload checksum... >&2
set "COMPUTED_SHA256="
for /f "skip=1 delims=" %%A in ('certutil -hashfile "%STAGE_DIR%\git.7z.exe" SHA256 ^| findstr /v "CertUtil"') do call :set_computed_sha256 "%%A"

if /i not "%COMPUTED_SHA256%"=="%GIT_EXPECTED_SHA256%" (
    echo. >&2
    echo =============================================================== >&2
    echo SECURITY ERROR: Cryptographic checksum mismatch detected. >&2
    echo Expected: %GIT_EXPECTED_SHA256% >&2
    echo Received: %COMPUTED_SHA256% >&2
    echo =============================================================== >&2
    rmdir /s /q "%STAGE_DIR%"
    exit /b 1
)
echo [Wrapper] Integrity verification successful. SHA256 matches. >&2

echo [Wrapper] Extracting archive package... >&2
"%STAGE_DIR%\git.7z.exe" -y -o"%STAGE_DIR%\portable_git" >nul
set "EXTRACT_STATUS=%errorlevel%"
del /q "%STAGE_DIR%\git.7z.exe" 2>nul

if not "%EXTRACT_STATUS%"=="0" (
    echo Error: Extracting the hermetic Git toolchain failed with status %EXTRACT_STATUS% >&2
    rmdir /s /q "%STAGE_DIR%"
    exit /b 1
)
if not exist "%STAGE_DIR%\portable_git\cmd\git.exe" (
    echo Error: cmd\git.exe is missing from the extracted toolchain >&2
    rmdir /s /q "%STAGE_DIR%"
    exit /b 1
)
if not exist "%STAGE_DIR%\portable_git\bin\bash.exe" (
    echo Error: bin\bash.exe is missing from the extracted toolchain >&2
    rmdir /s /q "%STAGE_DIR%"
    exit /b 1
)

:: Publish with a rename.  If another process won the race then GIT_CACHE_DIR
:: already exists, and move drops our copy inside it rather than replacing it,
:: so undo that and keep theirs -- it passed the same checks ours did.
move "%STAGE_DIR%\portable_git" "%GIT_CACHE_DIR%" >nul 2>&1
if exist "%GIT_CACHE_DIR%\portable_git" rmdir /s /q "%GIT_CACHE_DIR%\portable_git"
rmdir /s /q "%STAGE_DIR%" 2>nul

if not exist "%GIT_EXE_PATH%" (
    echo Error: Failed to install the hermetic Git toolchain into %GIT_CACHE_DIR% >&2
    exit /b 1
)

echo [Wrapper] Isolated Git runtime setup completed successfully. >&2
exit /b 0
