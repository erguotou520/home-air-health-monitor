## 说明

### pi
新建`config.py`文件，配置如下
```python
# -*- coding: utf-8 -*

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
#### 开机启动
1. 修改`/etc/rc.local`文件，加入`python xxx/app.py &`
2. 在`/usr/lib/systemd/system/`目录添加`monitor.py`，然后`sudo systemctl enable monitor`加入开机启动
