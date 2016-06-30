echo "========= Verifying St2 ========="
st2ctl status
echo "========== Test Action =========="
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
