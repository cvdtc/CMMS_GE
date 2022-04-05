import React from "react";
import 'chart.js/auto';
import { Line } from "react-chartjs-2";

function ChartActivity({dataLine}) {
  const data = {
    labels: dataLine.map((item)=>item.tanggal),
    datasets: [
      {
        backgroundColor: ["#41B883", "#DD1B16", "#4B16DD"],
        data: dataLine.map((item)=>item.jumlah_activity),
      },
    ],
    options: {
      responsive: !0,
      maintainAspectRatio: !1,
      defaultColor: '#eee',
      defaultFontColor: '#eee',
      layout: {
        padding: 0
      },
      llegend: {
        display: false
     },
     tooltips: {
        enabled: false
     },}
  };
  return <Line data={data}/>;
}

export default ChartActivity;
