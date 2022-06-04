#changeCtrl.reg ：windows 把Cpas按键映射到Ctrl键

1. 下载`changeCtrl.reg`后双击进行注册
2. 查看注册表编辑器是否修改成功
> - Windows键 + R 打开运行对话框
- 对话框中输入regedit
- 依次打开：
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout`
- 会发现注册的内容在一个Map里
3. reboot
