#!/bin/sh

OWASP_DIR=/usr/share/dependency-check/bin/          # OWASP Dependency check home directory

cat $OWASP_DIR/HELP.txt                              # Print HELP (confluence link, slack channel etc)

source $OWASP_DIR/config.ini                        # Sourcing configuration file

usage()
{   
    echo "Argument(s) missing"
    echo "usage: odc-wrapper.sh -p <app_name> [-s <suppression_file>] [-l <log_path>]"
    exit 1
}

while (( "$#" )); do
  case "$1" in
    -s|--suppression)                               # Get SUPPRESSION FILE from CMD line
    SUPPRESSION_FILE=$2
    shift
    shift
    ;;
    -l|--log)                                       # Get LOG PATH from CMD line
    LOG_PATH=$2
    shift
    shift
    ;;
    -p|--project)                                   # Get SUPPRESSION FILE from CMD line
    APP_NAME=$2
    shift
    shift
    ;;
    -*|--*=|*)                                      # Handle unsupported flags
    usage
    ;;
  esac
done

if [[ ! -f "$SUPPRESSION_FILE" ]]; then             # If SUPPRESSION file is not supplied, use default
    SUPPRESSION_FILE="$DEFAULT_SUPPRESSION_FILE" 
fi

if [[ -z "$LOG_PATH" ]]; then                       # If LOG path is not supplied, use default
    LOG_PATH="$DEFAULT_LOG_PATH"
fi

if [[ -z "$APP_NAME" ]]; then                       # APP_NAME is mandatory. Fail, if not supplied
    usage
fi
    
echo "Scan WITH failOnCVSS=$FAIL_ON_CVSS"
echo "Log file is at $LOG_PATH"
echo "Report file is at $REPORT_PATH"

# sh $OWASP_DIR/dependency-check.sh                 # Call OWASP depdencency checker
#    --propertyfile "$SETTINGS_FILE"                # Timeout and other settings
#    --disableBundleAudit                           # Disable Ruby analyzer
#    --scan /src                                    # Source folder to scan 
#    --project "$APP_NAME"                          # Application name 
#    --suppression "$SUPPRESSION_FILE"              # Path to SUPPRESSION file 
#    --failOnCVSS "$FAIL_ON_CVSS"                   # CVSS score to fail on
#    --log "$LOG_FILE"                              # Path to log file
#    --noupdate                                     # Do not run getupdates() at all

sh $OWASP_DIR/dependency-check.sh \
    --propertyfile "$SETTINGS_FILE" \
    --disableBundleAudit \
    --scan /src \
    --project "$APP_NAME" \
    --suppression "$SUPPRESSION_FILE" \
    --failOnCVSS "$FAIL_ON_CVSS" \
    --log "$LOG_PATH" \
    --noupdate
    
RETVAL=$?                                           # Get return value from dependency-check.sh

echo "Scan exiting with code: $RETVAL"

exit $RETVAL
