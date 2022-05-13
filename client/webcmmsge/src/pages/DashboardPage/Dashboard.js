import React from "react";

/// import navigation bar
import NavbarComponent from "../../components/Navbar";
// import SidebarComponent from "../../components/sidebar";

// | import required component
import axios from "../../utils/server";
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
    return (
      <>
        {/* /// navigation bar */}
        <NavbarComponent />
        <div className="md:container md:mx-auto mt-6">
          {/* /// page name */}
          <h1 className="text2xl font-medium text-gray-400 mt-4 mb-12 text-left">
            Dashboard
          </h1>
          {/* /// card jml masalah */}
          <div className="grid grid-rows-2 grid-flow-col gap-4">
            <div className="row-span-3">
              <div className="card p-5">
                <h6 className="text-grey-400">Total Masalah</h6>
                <h2 className="mt-2 text-red-600">{dashboarddata.jml_masalah}</h2>
              </div>
            </div>
            {/* /// card jml selesai masalah */}
            <div className="row-span-3">
              <div className="card p-5">
                <h6 className="text-grey-400">Total Selesai</h6>
                <h2 className="mt-2 text-red-600">{dashboarddata.jml_selesai}</h2>
              </div>
            </div>
            {/* /// chart monitoring activity */}
            <div className="row-span-2 col-span-2">
              {summaryinput !== "" && (
                <div className="card p-5">
                  <h3>Monitoring Activity</h3>
                  <ChartActivity dataLine={summaryinput} />
                </div>
              )}
            </div>
          </div>
        </div>
      </>
    );
  }
}

export default Dashboard;