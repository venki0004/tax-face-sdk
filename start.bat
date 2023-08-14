@echo off
echo [Pre-Requirement] Makesure install JDK 8.0+ and set the JRE_HOME.

set JAVA_EXE=D:\"Program Files"\Java\jre8\bin\java
set JAVA_OPTS=%JAVA_OPTS% -server -Xmx2g -XX:MetaspaceSize=128m -Dfile.encoding=UTF-8
set SERVER_NAME=tdx-face-sdk-server_release.jar

echo [Step] start application.
echo "%JAVA_EXE% %JAVA_OPTS% -jar %SERVER_NAME%"
start "TdxFaceSdkServer" %JAVA_EXE% %JAVA_OPTS% -Dlogging.file=logs\stdout.%date:~0,4%%date:~5,2%%date:~8,2%.log -jar %SERVER_NAME%
if errorlevel 1 goto error

echo [INFO] Please wait a moment. When you see "[INFO] Started TdxFaceSdkServerApplication in xxx seconds" in console, you can access below api:
echo [INFO] http://localhost:8190/api/xxx

goto end
:error
echo Error Happen!!
:end
pause