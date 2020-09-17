// 一定サンプル数ごとの平均を算出
function getAvgArr(arr, span) {
  let sum = 0, getavgidx = span -1;
  let r = new Array(Math.ceil(arr.length / span));
  let ridx = 0;
  for(let i = 0; i < arr.length; ++i) {
    sum += arr[i];
    if(getavgidx == i) {
      r[ridx++] = sum / span;
      getavgidx += span;
      sum = 0;
    }
  }
  // "切れ端"を処理
  if(getavgidx != (arr.length -1)) { r[ridx] = sum / (arr.length % span); }
  return r;
}


// データをplot
function plotData(data) {
  // 温度データ変換：描画負荷軽減のため一定サンプルごとの平均に変換
  // {
  //   // x,y軸でデータ分離し平均算出
  //   const span = 10
  //   const tmpX = getAvgArr(data.temp.map(v => v[0]), span);
  //   const tmpY = getAvgArr(data.temp.map(v => v[1]), span);
  //   // x,yでデータ結合
  //   data.temp = new Array(tmpX.size)
  //   for(let i = 0; i < tmpX.length; ++i) {
  //     data.temp[i] = { x:tmpX[i]*1000, y:tmpY[i] };
  //   }
  //   // console.log(data.temp);
  // }
  // => 不要になったためCO2濃度同様に形式変換のみに
  data.temp = data.temp.map(v => ({ x:(v[0]*1000), y:v[1] }))
  // CO2濃度データ変換：形式変換のみ
  data.co2 = data.co2.map(v => ({ x:(v[0]*1000), y:v[1] }))

  // グラフ描画オプション生成
  const ctx = document.getElementById("co2ScatterChart");
  const xax = [{
    type: 'time',
    time: { displayFormats: { hour: "MM/DD HH:mm" } },
    position: 'bottom',
  }];
  const yax = [
    {
      type: 'linear',
      scaleLabel: {
        display:true,
        labelString: 'CO2 [ppm]',
      },
      display: true,
      position: 'left',
      id: 'y-axis-1',
    },{
      type: 'linear',
      scaleLabel: {
        display:true,
        labelString: 'temperature [℃]',
      },
      display: true,
      position: 'right',
      id: 'y-axis-2',
    }
  ]
  const co2PlotOpt = {
    label: 'CO2',
    xAxisID: 'x-axis-1',
    yAxisID: 'y-axis-1',
    data: data.co2,
    showLine: true,
    fill: false,
    backgroundColor: 'RGBA(255, 99, 132, 0.8)',
  };
  const tempPlotOpt = {
    label: 'Temperature',
    xAxisID: 'x-axis-1',
    yAxisID: 'y-axis-2',
    data: data.temp,
    showLine: true,
    fill: false,
    backgroundColor: 'RGBA(255, 205, 86, 0.8)',
  };
  const chopt = {
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
  const fm = document.forms.dateselector;
  return [fm.date1, fm.date2];
}
// 表示期間変更時処理
function changeDate(e) {
  const s = getDateForm().map(x => x.value);
  const u = `./getdata.rb?d1=${s[0]}&d2=${s[1]}`;
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

