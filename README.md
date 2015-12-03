# 计算机网络作业自动化工具

**STEP1** 安装gnuplot

**STEP2** 安装老师给的tapo.

**STEP3** 安装本自动化工具
```
git clone https://github.com/freemandealer/homework-tool.git
chmod +x get_result.sh
```
修改get_result.sh最上面的tapo路径为你机器上tapo的安装路径.
```
TCP_TOOL=/your/real/tapo/path/tcp_tool
```
**STEP4**　将Wireshark得到的pcap文件拷贝到homework-tool目录.
```	
./get_result.sh  <待分析的pcap文件>
```

执行完成后将在/homework-tool/results下看到结果:

- *.dat文件是数据
- *.jpg文件是图表

![](http://i12.tietuku.com/992c53330ba299a5.png)

<freeman.zhang1992@gmail.com>