import React, { Component } from "react";

/// import navigation bar
import NavbarComponent from "../../components/Navbar";
// import SidebarComponent from "../../components/sidebar";

// | import required component
import axios from "../../utils/server";
import PieChart from "./PieChart";
import ChartActivity from "./ChartActivity";
import "./dashbord.css";

class Dashboard extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      dashboarddata: [],
      summaryinput: [],
    };
  }

  componentDidMount() {
    axios
      .get("dashboard", {
        headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
      })
      .then((response) => {
        console.log(response, response.data.data[0].jml_masalah);
        this.setState({ dashboarddata: response.data.data[0] });
      })
      .catch((error) => console.log(error));
    axios
      .get("dashboardinputsummary", {
        headers: {
          Authorization: `Bearer ` + localStorage.getItem("token"),
        },
      })
      .then((responsesummary) => {
        console.log("summary", responsesummary.data.data);
        this.setState({ summaryinput: responsesummary.data.data });
        console.log("SD", this.summaryinput);
      })
      .catch((error) => console.log(error));
  }
  render() {
    const { dashboarddata, summaryinput } = this.state;
    // console.log('xxx', summaryinput.jumlah_activity, summaryinput.tanggal);
    return (
      <div>
        <NavbarComponent />
        <div className="container">
          <div className="dashboard">
            <div className="feature">
              <div className="featureItem">
                <div className="featureTitle">Jumlah Activity</div>
                {dashboarddata !== "" && (
                  <PieChart
                    masalah={dashboarddata.jml_masalah}
                    selesai={dashboarddata.jml_selesai}
                  />
                )}{" "}
                <p>Jumlah Activity {dashboarddata.jml_masalah}</p>
                <p>Jumlah Activity Selesai {dashboarddata.jml_selesai}</p>
              </div>
            </div>
          </div>
          <div className="feature">
              <div className="featureItem">
                <div className="featureTitle">Monitoring Activity</div>
                {summaryinput !== "" && (
                  <ChartActivity dataLine={summaryinput} />
                )}
              </div>
            </div>
        </div>
      </div>
    );
  }
}

export default Dashboard;


{/* <div className="col-lg-9 mb-2 d-flex align-items-stretch align-content-center">
<div className="card" style={{ width: '38rem' }}>

  <div className="card-title "><p class="text-uppercase small mb-2"><strong>Traffic activity 14 hari</strong></p></div>
  <hr className="my-0"/>
  <div className="card-body">
  {summaryinput !== "" && (
    <ChartActivity dataLine={summaryinput} />
  )}
  </div>
</div>
</div> */}