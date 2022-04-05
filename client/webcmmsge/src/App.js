import React, { Component } from "react";

// | import required library
/// import router dom for navigate
import { Routes, Route, useNavigate } from "react-router-dom";
/// import axios
// import axios from "./utils/server";
/// import Auth validation
import { TokenValidation } from "./utils/AuthValidation";
import { Navigate, Outlet } from "react-router-dom";
/// import detected devices if using mobile please download apk
import { isMobile } from "react-device-detect";

// | import pages
/// import auth validation route
import PrivateRoute from "./utils/PrivateRoute";

/// import login page
import LoginPage from "./pages/LoginPage/Login";

/// import dashboard page
import DashboardPage from "./pages/DashboardPage/Dashboard";

/// import master mesin
import ListMesin from "./pages/Master/Mesin/list";

/// import master site
import ListSite from "./pages/Master/Site/list";
import AddSite from "./pages/Master/Site/add";

/// import master komponen
import ListKomponen from "./pages/Master/Komponen/list";

/// import transaksi activity
import ListActivity from "./pages/Transaksi/Activity/list"

/// import transaksi preactivity
import ListPreActivity from "./pages/Transaksi/PreActivity/list"

/// import transaksi checlist
import ListChecklist from "./pages/Transaksi/Checklist/list"

// ! DEBUGING
import TestSidebar from "./components/Sidebar/sidebar";

/// handle for token validation, if token auth will be route to dashboard and if unauth go back to login
const AuthHandler = () => {
  TokenValidation().then((response) => {
    const tokenauth = response.data.data;
    if (tokenauth === true) {
      console.log("dashboard");
      return <Navigate to="/dashboard" />;
    } else {
      console.log("login");
      return <Outlet />;
    }
  });
};


class App extends Component {
  async componentDidMount() {
    AuthHandler();
    if (localStorage.getItem("token")!=='') {
      return <Navigate to="/dashboard"/>
    } else {
      return <Navigate to='/'/>
    }
  }

  render() {
    if (isMobile) {
      return <div className="containerd-flex justify-content-center"> This content is unavailable on mobile, Please download apps</div>;
    }
    return (
      <div>
        <Routes>
          <Route exact path="/" element={<LoginPage />} />
          <Route exact path="/sidebar" element={<PrivateRoute />}>
            <Route exact path="/sidebar" element={<TestSidebar />} />
          </Route>
          <Route exact path="/dashboard" element={<PrivateRoute />}>
            <Route exact path="/dashboard" element={<DashboardPage />} />
          </Route>
          <Route exact path="/datamesin" element={<PrivateRoute />}>
            <Route exact path="/datamesin" element={<ListMesin/>} />
          </Route>
          <Route exact path="/datasite" element={<PrivateRoute />}>
            <Route exact path="/datasite" element={<ListSite/>} />
          </Route>
          <Route exact path="/datakomponen" element={<PrivateRoute />}>
            <Route exact path="/datakomponen" element={<ListKomponen/>} />
          </Route>
          <Route exact path="/dataactivity" element={<PrivateRoute />}>
            <Route exact path="/dataactivity" element={<ListActivity/>} />
          </Route>
          <Route exact path="/datapreactivity" element={<PrivateRoute />}>
            <Route exact path="/datapreactivity" element={<ListPreActivity/>} />
          </Route>
          <Route exact path="/datachecklist" element={<PrivateRoute />}>
            <Route exact path="/datachecklist" element={<ListChecklist/>} />
          </Route>
          <Route exact path="/addsite" element={<PrivateRoute />}>
            <Route exact path="/addsite" element={<AddSite/>} />
          </Route>
          {/* <Route exact path="/dashboard" element={<DashboardPage />} /> */}
        </Routes>
      </div>
    );
  }
}

export default App;
