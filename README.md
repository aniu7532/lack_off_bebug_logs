##简易的异常捕获以及dio请求日志显示窗口，支持Android、ios、鸿蒙

##使用步骤

//初始化
1. LackOff.initialize(const MyApp());

2. 添加dio拦截器
   dio.interceptors.add(
   PrettyDioLogger(
   request: true,
   requestHeader: true,
   responseHeader: true,
   responseBody: true,
   ),
   );
//显示button
3. LackOff.showLackOffButton(context);



//手动新增日志
LackOff.addLog(LackOffBean(
logType:'',
logTitle: '',
logDetail: '',
date: DateTime.now().toString(),
));

鸿蒙next 模拟器
![img.gif](https://github.com/aniu7532/lack_off_bebug_logs/blob/0.0.2/Nov-04-2024%2014-08-07.gif)

![img.png](https://raw.githubusercontent.com/aniu7532/lack_off_bebug_logs/0.0.2/1730363514776.jpg)
