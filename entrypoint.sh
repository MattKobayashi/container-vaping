#!/bin/sh
# Ensures cleanup of the PID file on container stop

set -e

PID_FILE="/opt/vaping/vaping.pid"

# Cleanup function to remove the PID file
cleanup() {
  echo "Received signal, cleaning up PID file: $PID_FILE"
  rm -f "$PID_FILE"
  echo "Cleanup finished."
  exit 0 # Exit gracefully after cleanup
}

# Trap common termination signals (SIGINT, SIGTERM, SIGQUIT)
trap cleanup INT TERM QUIT

# Start vaping in the background
echo "Starting vaping..."
# Note: Using the full path to vaping installed via pipx
/opt/vaping/.local/bin/vaping start --home=/opt/vaping --no-fork &

# Get the PID of the background vaping process
VAPING_PID=$!
echo "Vaping started with PID $VAPING_PID"

# Wait for the vaping process to exit
wait $VAPING_PID

# Capture the exit code of vaping
EXIT_CODE=$?
echo "Vaping process exited with code $EXIT_CODE. Performing cleanup..."

# Perform cleanup in case of normal exit (trap handles signal exits)
rm -f "$PID_FILE"
echo "Final cleanup finished."

# Exit the script with the same exit code as vaping
exit $EXIT_CODE
