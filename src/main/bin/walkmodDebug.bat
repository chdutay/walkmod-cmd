@REM ----------------------------------------------------------------------------
@REM Licensed to the Apache Software Foundation (ASF) under one
@REM or more contributor license agreements.  See the NOTICE file
@REM distributed with this work for additional information
@REM regarding copyright ownership.  The ASF licenses this file
@REM to you under the Apache License, Version 2.0 (the
@REM "License"); you may not use this file except in compliance
@REM with the License.  You may obtain a copy of the License at
@REM
@REM    http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing,
@REM software distributed under the License is distributed on an
@REM "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
@REM KIND, either express or implied.  See the License for the
@REM specific language governing permissions and limitations
@REM under the License.
@REM ----------------------------------------------------------------------------

@REM ----------------------------------------------------------------------------
@REM WALKMOD Start Up Batch script
@REM
@REM Required ENV vars:
@REM JAVA_HOME - location of a JDK home dir
@REM
@REM Optional ENV vars
@REM WALKMOD_HOME - location of WALKMOD2's installed home dir
@REM WALKMOD_BATCH_ECHO - set to 'on' to enable the echoing of the batch commands
@REM WALKMOD_BATCH_PAUSE - set to 'on' to wait for a key stroke before ending
@REM WALKMOD_OPTS - parameters passed to the Java VM when running WALKMOD
@REM     e.g. to debug WALKMOD itself, use
@REM set WALKMOD_OPTS=-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=1044
@REM ----------------------------------------------------------------------------

@REM Begin all REM lines with '@' in case WALKMOD_BATCH_ECHO is 'on'
@echo off
@REM enable echoing my setting WALKMOD_BATCH_ECHO to 'on'
@if "%WALKMOD_BATCH_ECHO%" == "on"  echo %WALKMOD_BATCH_ECHO%

set WALKMOD_DEBUG_OPTS=-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=1044
@echo Preparing to Execute WALKMOD in Debug Mode

@REM set %HOME% to equivalent of $HOME
if "%HOME%" == "" (set "HOME=%HOMEDRIVE%%HOMEPATH%")

@REM Execute a user defined script before this one
if exist "%HOME%\walkmodrc_pre.bat" call "%HOME%\walkmodrc_pre.bat"

set ERROR_CODE=0

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal
if "%OS%"=="WINNT" @setlocal

@REM ==== START VALIDATION ====
if not "%JAVA_HOME%" == "" goto OkJHome

echo.
echo ERROR: JAVA_HOME not found in your environment.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation
echo.
goto error

:OkJHome
if exist "%JAVA_HOME%\bin\java.exe" goto chkMHome

echo.
echo ERROR: JAVA_HOME is set to an invalid directory.
echo JAVA_HOME = "%JAVA_HOME%"
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation
echo.
goto error

:chkMHome
if not "%WALKMOD_HOME%"=="" goto valMHome

if "%OS%"=="Windows_NT" SET "WALKMOD_HOME=%~dp0.."
if "%OS%"=="WINNT" SET "WALKMOD_HOME=%~dp0.."
if not "%WALKMOD_HOME%"=="" goto valMHome

echo.
echo ERROR: WALKMOD_HOME not found in your environment.
echo Please set the WALKMOD_HOME variable in your environment to match the
echo location of the WALKMOD installation
echo.
goto error

:valMHome

:stripMHome
if not "_%WALKMOD_HOME:~-1%"=="_\" goto checkMBat
set "WALKMOD_HOME=%WALKMOD_HOME:~0,-1%"
goto stripMHome

:checkMBat
if exist "%WALKMOD_HOME%\bin\walkmod.bat" goto init

echo.
echo ERROR: WALKMOD_HOME is set to an invalid directory.
echo WALKMOD_HOME = "%WALKMOD_HOME%"
echo Please set the WALKMOD_HOME variable in your environment to match the
echo location of the WALKMOD installation
echo.
goto error
@REM ==== END VALIDATION ====

:init
@REM Decide how to startup depending on the version of windows

@REM -- Windows NT with Novell Login
if "%OS%"=="WINNT" goto WinNTNovell

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

:WinNTNovell

@REM -- 4NT shell
if "%@eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set WALKMOD_CMD_LINE_ARGS=%*
goto endInit

@REM The 4NT Shell from jp software
:4NTArgs
set WALKMOD_CMD_LINE_ARGS=%$
goto endInit

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of agruments (up to the command line limit, anyway).
set WALKMOD_CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto endInit
set WALKMOD_CMD_LINE_ARGS=%WALKMOD_CMD_LINE_ARGS% %1
shift
goto Win9xApp

@REM Reaching here means variables are defined and arguments have been captured
:endInit
SET WALKMOD_JAVA_EXE="%JAVA_HOME%\bin\java.exe"

@REM -- 4NT shell
if "%@eval[2+2]" == "4" goto 4NTCWJars

@REM -- Regular WinNT shell
set CLASSWORLDS_JAR="%WALKMOD_HOME%\config";"%WALKMOD_HOME%\lib\*"
goto runWALKMOD

@REM The 4NT Shell from jp software
:4NTCWJars
set CLASSWORLDS_JAR="%WALKMOD_HOME%\config";"%WALKMOD_HOME%\lib\*"
goto runWALKMOD

@REM Start WALKMOD2
:runWALKMOD
%WALKMOD_JAVA_EXE% %WALKMOD_OPTS% %WALKMOD_DEBUG_OPTS% -classpath %CLASSWORLDS_JAR%  org.walkmod.WalkModDispatcher %WALKMOD_CMD_LINE_ARGS%
if ERRORLEVEL 1 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
if "%OS%"=="WINNT" @endlocal
set ERROR_CODE=1

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT
if "%OS%"=="WINNT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set WALKMOD_JAVA_EXE=
set WALKMOD_CMD_LINE_ARGS=
goto postExec

:endNT
@endlocal & set ERROR_CODE=%ERROR_CODE%

:postExec
if exist "%HOME%\walkmodrc_post.bat" call "%HOME%\walkmodrc_post.bat"
@REM pause the batch file if WALKMOD_BATCH_PAUSE is set to 'on'
if "%WALKMOD_BATCH_PAUSE%" == "on" pause

if "%WALKMOD_TERMINATE_CMD%" == "on" exit %ERROR_CODE%

exit /B %ERROR_CODE%

