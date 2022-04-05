import React from "react";
import 'chart.js/auto';
import { Doughnut } from "react-chartjs-2";

function Piechart({ masalah, selesai }) {
  const data = {
    labels: ["Activity Selesai", "Jumlah Activity"],
    datasets: [
      {
        backgroundColor: ["#41B883", "#DD1B16"],
        data: [selesai, masalah],
      },
    ],
    
  };
  return <Doughnut data={data} />;
}

export default Piechart;
