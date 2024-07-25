#!/usr/bin/env bash
# ===============================
# RunLangTool.sh
# Collin F. Lynch
#
# This script provides a simple bash wrapper for executing the
# language tool as a service.  It requires specification of the
# basic libratry paths but relies on the internal server for
# most of the work.  

# System Variables
# --------------------------------------
# Set the absolute path for the necessary VM, language tool library, and
# logging location.  The default values here assume you are executing it
# in a local directory.
VIRTUALENV_PATH="./VirtualENVs/LTenv/"
LANGTOOL_LOC="./AWE_LanguageTool/"
LOGFILE_DEST="./"

# We format a datetime stamped logfile for future reference.
# ---------------------------------------
LOG_DATE=$(date "+%m-%d-%Y--%H-%M-%S")
LOGFILE_NAME="$LOGFILE_DEST/language_tool_$LOG_DATE.log"
echo $LOG_NAME;
 
# Load the virtual env and execute.
# --------------------------------------
echo "Running Language Tool Service..."
cd $LANGTOOL_LOC
source $VIRTUALENV_PATH/bin/activate
nohup python awe_languagetool/languagetoolServer.py > $LOGFILE_NAME 2>&1 &
PROCESS_ID=$!
echo $PROCESS_ID > $LOGFILE_DEST/langtoolrun.pid

# To avoid any process limits we set large file counts.
prlimit --pid $PROCESS_ID --nofile=8192
