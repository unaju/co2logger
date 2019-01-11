// データをplot
function plotData(data) {
  // 形式変換
  ['co2', 'temp'].forEach(key => {
    data[key] = data[key].map(v => ({ x:new Date(v[0]*1000), y:v[1] }))
  });
  // plotData.prototype.pdata = data;

  // グラフ描画オプション生成
  var ctx = document.getElementById("co2ScatterChart");
  var xax = [{
    type: 'time',
    time: { displayFormats: { hour: "MM/DD HH:mm" } },
    position: 'bottom',
  }];
  var yax = [
    {
      type: 'linear',
      labelString: 'CO2 [ppm]',
      display: true,
      position: 'left',
      id: 'y-axis-1',
    },{
      type: 'linear',
      labelString: 'temperature [℃]',
      display: true,
      position: 'right',
      id: 'y-axis-2',
    }
  ]
  var co2PlotOpt = {
    label: 'CO2',
    xAxisID: 'x-axis-1',
    yAxisID: 'y-axis-1',
    data: data.co2,
    backgroundColor: 'RGBA(255, 99, 132, 0.8)',
  };
  var tempPlotOpt = {
    label: 'Temperature',
    xAxisID: 'x-axis-1',
    yAxisID: 'y-axis-2',
    data: data.temp,
    backgroundColor: 'RGBA(255, 205, 86, 0.8)',
  };
  var chopt = {
    type: 'scatter', 
    data: { datasets: [co2PlotOpt, tempPlotOpt] },
    options: {
      scales: { xAxes: xax, yAxes: yax }
    }
  };
  // グラフ更新
  if (plotData.prototype.chart) { plotData.prototype.chart.destroy() };
  plotData.prototype.chart = new Chart(ctx, chopt);
}

// 日付入力フォーム取得
function getDateForm() {
  var fm = document.forms.dateselector;
  return [fm.date1, fm.date2];
}
// 表示期間変更時処理
function changeDate(e) {
  var s = getDateForm().map(x => x.value);
  var u = `./getdata.rb?d1=${s[0]}&d2=${s[1]}`;
  console.log(u);
  jQuery.getJSON(u, plotData);
}

// 入力可能な日付の範囲を取得し期間を設定
function setDateRange(res) {
  if (!res) { return };
  getDateForm().forEach(f => {
    f.min = res[0]
    f.value = f.max = res[1] // 最後の情報を指定
    f.onchange = changeDate // 日付変更時の処理を有効化
  });
  changeDate(null); // 最後の情報を表示
}

// 表示ルーチン開始
function GetDateRange() {
  jQuery.getJSON('./get_date_range.rb', setDateRange);
}

