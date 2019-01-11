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
      id: 'y-ax-co2',
    },{
      type: 'linear',
      labelString: 'temperature [℃]',
      display: true,
      position: 'right',
      id: 'y-ax-temp',
    }
  ]
  var co2PlotOpt = {
    label: 'CO2',
    // yAxisID: 'y-ax-co2',
    data: data.co2,
    backgroundColor: 'RGBA(165,35,9, 20)',
  };
  var tempPlotOpt = {
    label: 'Temperature',
    // yAxisID: 'y-ax-temp',
    data: data.temp,
    backgroundColor: 'RGBA(224,191,6, 20)',
  };
  var chopt = {
    type: 'scatter', 
    data: { datasets: [co2PlotOpt] },
    options: {
      scales: { xAxes: xax }
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

