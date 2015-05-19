# Information about a test account which used by st2_deploy
TEST_ACCOUNT_USERNAME="testu"
TEST_ACCOUNT_PASSWORD="testp"

echo "========= Verifying St2 ========="
st2ctl restart
sleep 5
echo "========== Test Action =========="
TOKEN=`st2 auth ${TEST_ACCOUNT_USERNAME} -p ${TEST_ACCOUNT_PASSWORD} | grep token | awk '{print $4}'`
ST2_AUTH_TOKEN=${TOKEN} st2 run core.local date
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
if [ ${INSTALL_WEBUI} == "1" ]; then
  echo "WebUI at http://`hostname`:8080/"
fi

echo "=========================================="
echo ""

echo "Test StackStorm user account details"
echo ""
echo "Username: ${TEST_ACCOUNT_USERNAME}"
echo "Password: ${TEST_ACCOUNT_PASSWORD}"
echo ""
echo "To login and obtain an authentication token, run the following command:"
echo ""
echo "st2 auth ${TEST_ACCOUNT_USERNAME} -p ${TEST_ACCOUNT_PASSWORD}"
echo ""
echo "For more information see http://docs.stackstorm.com/install/deploy.html#usage"
exit 0
