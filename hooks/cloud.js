// 获取今日数据
AV.Cloud.afterSave('todayData', function () {
  var keys = ['formaldehyde', 'pm25', 'temperature', 'humidity'];
  // 取今日数据
  var now = new Date();
  var from = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  var to = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1);
  var query1 = new AV.Query('Daily');
  query1.greaterThanOrEqualTo('createdAt', from);
  var query2 = new AV.Query('Daily');
  query2.lessThan('createdAt', to);
  return AV.Query.and(query1, query2).descending('createdAt').find().then(results => {
    // 计算各种值
    if (!results.length) return;
    var ret = { latest_time: results[0].get('createdAt') };
    results.forEach(data => {
      keys.forEach(key => {
        var _data = data.get(key);
        var _avgKey = `${key}_avg`;
        var _minKey = `${key}_min`;
        var _maxKey = `${key}_max`;
        if (!ret[key]) {
          ret[key] = _data
        }
        ret[_avgKey] = (ret[_avgKey] || 0) + _data;
        ret[_minKey] = ret[_minKey] ? Math.min(_data, ret[_minKey]) : _data;
        ret[_maxKey] = ret[_maxKey] ? Math.max(_data, ret[_maxKey]) : _data;
      });
    });
    keys.forEach(key => {
      var _avgKey = `${key}_avg`;
      ret[_avgKey] = Math.round(1000 * ret[_avgKey] / results.length) / 1000;
    });
    return ret;
  }).catch(e => console.error(e));
});

// 归档昨日数据
// cron 0 0 3 * * ? 每天3点执行
AV.Cloud.afterSave('tarData', function () {
  AV.Cloud.useMasterKey();
  var Tar = AV.Object.extend('Tar');
  var keys = ['formaldehyde', 'pm25', 'temperature', 'humidity'];
  // 取昨日数据
  var now = new Date();
  var from = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 1);
  var to = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  var query1 = new AV.Query('Daily');
  query1.greaterThanOrEqualTo('createdAt', from);
  var query2 = new AV.Query('Daily');
  query2.lessThan('createdAt', to);
  return AV.Query.and(query1, query2).find().then(results => {
      // 计算各种值
      if (!results.length) return;
      var tar = new Tar();
      results.forEach(data => {
        keys.forEach(key => {
          var _data = data.get(key);
          var _avgKey = `${key}_avg`;
          var _minKey = `${key}_min`;
          var _maxKey = `${key}_max`;
          var _avg = tar.get(_avgKey);
          var _min = tar.get(_minKey);
          var _max = tar.get(_maxKey);
          tar.set(_avgKey, _avg ? _avg + _data : _data);
          tar.set(_minKey, _min ? Math.min(_data, _min) : _data);
          tar.set(_maxKey, _max ? Math.max(_data, _max) : _data);
        });
      });
      AV.Object.destroyAll(results).catch(console.error)
      keys.forEach(key => {
          var _avgKey = `${key}_avg`;
          tar.set(_avgKey, Math.round(1000 * tar.get(_avgKey) / results.length) / 1000);
      });
      return tar.save();
  }).then(() => {}).catch(e => console.error(e));
});
