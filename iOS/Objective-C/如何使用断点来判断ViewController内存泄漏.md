1、选择 Breakpoint Navigator 
2、点击 +，选择 Symbolic Breakpoint...
3、将 `Symbol` 设值为 `-[UIViewController dealloc]`
4、点击 `Add Action` 按钮，选择 `Sound`，再设值为自己喜欢的声音(此处设值为 ping)
5、再次点击 `+` ，设值输出 action，选择 `Log Message`，设置打印的值：`--- dealloc @(id)[$arg1 description]@`
6、勾选 `Automatically continue after evaluating actions`，这样每次断点会自动通过
最后，通过上面的 6 步，你就可以享受无码检测内存泄漏的快感了😏。