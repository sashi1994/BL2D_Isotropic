@echo off
REM *****************************************************
REM Répertoire d'installation  :
REM *****************************************************

Set JOB_NAME=auto_inp
Set MACRO=Macro_Extract_U_S_shell

del %JOB_NAME%.lck
del %JOB_NAME%.odb


echo Lancement de ABAQUS

CALL abq2016 job=%JOB_NAME% interactive ask_delete=OFF 
CALL abq2016 cae noGUI=%MACRO%


echo FIN

