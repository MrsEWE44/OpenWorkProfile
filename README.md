# OpenWorkProfile

一个适用于安卓的多开脚本

支持任何安卓应用的多开

支持一键更新多开应用

支持一键移除所有多开账户


# 使用说明：

1.create work profile(新增工作空间)

选择该选项后，会列出用户0下所有第三方app的包名

你需要选择一个包名

please select package name : （选择一个应用包名，选择左边数字序号）

之后会询问你，你想要开启多少个工作空间

input open application num : (选择工作空间数量,默认最大值是1024个)

选择完后，它就会开始创建工作空间，并把你之前选择的应用包名重新安装到其他工作空间。

如果你之前已经有其他用户了，已经开了分区，然后再运行我的脚本，我会默认清理掉，因为会出现问题，所以必须要移除。

2.remove work profile（移除工作空间）

选择该选项后，会一键移除所有工作空间(包括里面安装的所有app跟数据)，只保留用户0的。

3.reinstall by user（安装应用到工作空间）

选择该选项后，会让你再重新选择一个包名安装到除0外，其他所有工作空间里面，也可以理解为，为其他所有工作分区更新、新增一个应用。

4.I want auto boot the work profile（让工作空间开机自启）

选择该选项后，会自动生成一个脚本到/data/adb/service.d，用于开机时执行“启动其他用户”的操作。

5.remove auto boot file（删除自启文件）

选择该选项后，会删除/data/adb/service.d用于开机时执行“启动其他用户”的脚本。

6.just add one work profile（再次新增一个工作空间）

选择该选项后，会重复1选项的操作，不过只是新增一个工作空间。

q.exit

退出脚本




# 修改时间：
# 2022年4月3日14点40分


