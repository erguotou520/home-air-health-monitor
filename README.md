## 说明

### pi
生产环境添加`PYTHON_ENV = production`的环境变量
新建`config.py`文件，配置如下
```python
config = {
  'server': {
    'host': "0.0.0.0",
    'port': 5555
  },
  'leancloud': {
    'appid': "xxx",
    'appkey': "xxx"
  }
}
```

#### 部署代码
```bash
scp -r pi pi@192.168.1.7:/home/pi/Desktop
```

#### 开机启动
使用`sudo`安装依赖`sudo pip install -r requirements.txt`
1. ~~修改`/etc/rc.local`文件，加入`python xxx/app.py &`~~
2. 在`/usr/lib/systemd/system/`目录添加`monitor.py`，然后`sudo systemctl enable monitor`加入开机启动

### app/home_air
新建`lib/config.dart`文件，配置如下
```dart
const APP_ID = 'xxx';
const APP_KEY = 'xxx';
```

### hooks
LeanCloud的云函数，共2个
