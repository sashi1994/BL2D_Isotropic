@echo off
REM *****************************************************
REM Répertoire d'installation  :
REM *****************************************************

Set JOB_NAME=auto_inp
Set MACRO=Macro_Extract_U_S

del %JOB_NAME%.lck
del %JOB_NAME%.odb


echo Lancement de ABAQUS

CALL C:\SIMULIA\Abaqus\Commands\abq6122.bat job=%JOB_NAME% interactive
CALL C:\SIMULIA\Abaqus\Commands\abq6122.bat cae noGUI=%MACRO% 

echo FIN

