����ָ����
1����java_perf_test�������ص�����
2����cmd����̨�У����뵽java_perf_testĿ¼
3��ִ��mvn clean install -DskipTests ������й���(�谲װmaven)
4�������ɹ��󣬿��ڹ�����־���ҵ���Ӧ��·��
5���������ɹ��İ��ϴ���Ҫ����ķ�������ѡ��jdk11������Ŀ java -Xlog:gc*=info,gc+heap=debug:file=/home/gc-%t.log -jar demo_test-0.0.1-SNAPSHOT.jar ������Ŀ
6�������ڶ˿�ռ��������������޸�application.yml�ļ��˿�����
��Ŀ�����ɹ���

�����������Ӵ�����־��
�ڴ����
http://ip:9118/gctest/testOOM
�����gc
http://ip:9118/gctest/young
ϵͳgc
http://ip:9118/gctest/systemgc
�����gc
http://ip:9118/gctest/bigdata
Ԫ�ռ�gc
http://ip:9118/gctest/metaspace

�ȵ㺯�����ã�
http://ip:9118/test/testHotMethod/20
http://ip:9118/test/testHotMethodTwo/20