# Disable Authentication in /etc/st2/st2/conf (set `enable = False` under `auth` config section)
#sed -i '/^\[auth\]$/,/^\[/ s/^enable = True/enable = False/' /etc/st2/st2.conf

# Information about a test account which used by st2_deploy
TEST_ACCOUNT_USERNAME="testu"
TEST_ACCOUNT_PASSWORD="testp"

echo "========= Verifying St2 ========="
st2ctl status
#sleep 10
echo "========== Test Action =========="
export ST2_AUTH_TOKEN=`st2 auth -t ${TEST_ACCOUNT_USERNAME} -p ${TEST_ACCOUNT_PASSWORD}`
st2 run core.local -- date -R
ACTIONEXIT=$?

echo "=============================="
echo ""

if [ ${ACTIONEXIT} -ne 0 ]
then
  echo "ERROR!" 
  echo "Something went wrong, st2 failed to start"
  exit 2
else
  echo "      _   ___     ____  _  __ "
  echo "     | | |__ \   / __ \| |/ / "
  echo "  ___| |_   ) | | |  | | ' /  "
  echo " / __| __| / /  | |  | |  <   "
  echo " \__ \ |_ / /_  | |__| | . \  "
  echo " |___/\__|____|  \____/|_|\_\ "
  echo ""
  echo "  st2 is installed and ready  "
fi
echo "StackStorm WebUI at https://`hostname`/"

echo "=========================================="
echo ""

echo "StackStorm UI user account details"
echo ""
echo "Username: ${TEST_ACCOUNT_USERNAME}"
echo "Password: ${TEST_ACCOUNT_PASSWORD}"
echo ""
exit 0
