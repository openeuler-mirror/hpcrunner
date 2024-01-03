
echo '输入 1 到 4 之间的数字，选择合适的github源'
echo '1) 官方源'
echo '2) 美国高速源1'
echo '3) 美国高速源2'
echo '4) 美国高速源3'
echo '5) 韩国高速源1'

echo '你输入的数字为:'
read aNum
case $aNum in
    1)  sed -i -e 's/JARVIS_PROXY=.*/JARVIS_PROXY=https:\/\/github.com/g' init.sh
    ;;
    2)  sed -i -e 's/JARVIS_PROXY=.*/JARVIS_PROXY=https:\/\/gh.ddlc.top\/https:\/\/github.com/g' init.sh
    ;;
    3)  sed -i -e 's/JARVIS_PROXY=.*/JARVIS_PROXY=https:\/\/gh.con.sh\/https:\/\/github.com/g' init.sh
    ;;
    4)  sed -i -e 's/JARVIS_PROXY=.*/JARVIS_PROXY=https:\/\/hub.gitmirror.com\/https:\/\/github.com/g' init.sh
    ;;
    5)  sed -i -e 's/JARVIS_PROXY=.*/JARVIS_PROXY=https:\/\/ghproxy.com\/https:\/\/github.com/g' init.sh
    ;;
    *)  echo '你没有输入 1 到 5 之间的数字'
    ;;
esac




