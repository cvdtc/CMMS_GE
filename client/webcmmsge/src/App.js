import React, { Component } from "react";

// | import required library
/// import router dom for navigate
import { Routes, Route } from "react-router-dom";
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
import AddMesin from "./pages/Master/Mesin/add"
import EditMesin from "./pages/Master/Mesin/edit"

/// import master site
import ListSite from "./pages/Master/Site/list";
import AddSite from "./pages/Master/Site/add";
import EditSite from "./pages/Master/Site/edit";

/// import master komponen
import ListKomponen from "./pages/Master/Komponen/list";
import AddKomponen from "./pages/Master/Komponen/add";
import EditKomponen from "./pages/Master/Komponen/edit";

/// import report dataproduksi plant3
import Dataproduksi from "./pages/Report/produksi/dataproduksi";

/// import transaksi activity
import ListActivity from "./pages/Transaksi/Activity/list"
import AddActivity from "./pages/Transaksi/Activity/add"

/// import transaksi preactivity
import ListPreActivity from "./pages/Transaksi/PreActivity/list"
import AddPreActivity from "./pages/Transaksi/PreActivity/add"

/// import transaksi checlist
import ListChecklist from "./pages/Transaksi/Checklist/list"

/// import Page not found!
import NotfountPage from "./pages/404/404"

// ! DEBUGING
// import TestSidebar from "./components/Sidebar/sidebar";

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
    if (localStorage.getItem("token") !== '') {
      return <Navigate to="/dashboard" />
    } else {
      return <Navigate to='/' />
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
          {/* <Route exact path="/sidebar" element={<PrivateRoute />}>
            <Route exact path="/sidebar" element={<TestSidebar />} />
          </Route> */}
          {/* /// dashboard */}
          <Route exact path="/dashboard" element={<PrivateRoute />}>
            <Route exact path="/dashboard" element={<DashboardPage />} />
          </Route>
          {/* /// mesin */}
          {/* // | list mesin */}
          <Route exact path="/datamesin" element={<PrivateRoute />}>
            <Route exact path="/datamesin" element={<ListMesin />} />
          </Route>
          {/* // | add mesin */}
          <Route exact path="/addmesin" element={<PrivateRoute />}>
            <Route exact path="/addmesin" element={<AddMesin />} />
          </Route>
          {/* // | edit mesin */}
          <Route exact path="/editmesin" element={<PrivateRoute />}>
            <Route exact path="/editmesin" element={<EditMesin />} />
          </Route>
          {/* /// site */}
          {/* // | list site */}
          <Route exact path="/datasite" element={<PrivateRoute />}>
            <Route exact path="/datasite" element={<ListSite />} />
          </Route>
          {/* // | add site */}
          <Route exact path="/addsite" element={<PrivateRoute />}>
            <Route exact path="/addsite" element={<AddSite />} />
          </Route>
          {/* // | edit site */}
          <Route exact path="/editsite" element={<PrivateRoute />}>
            <Route exact path="/editsite" element={<EditSite />} />
          </Route>
          {/* /// komponen */}
          {/* // | list komponen */}
          <Route exact path="/datakomponen" element={<PrivateRoute />}>
            <Route exact path="/datakomponen" element={<ListKomponen />} />
          </Route>
          {/* // | add komponen */}
          <Route exact path="/addkomponen" element={<PrivateRoute />}>
            <Route exact path="/addkomponen" element={<AddKomponen />} />
          </Route>
          {/* // | edit komponen */}
          <Route exact path="/editkomponen" element={<PrivateRoute />}>
            <Route exact path="/editkomponen" element={<EditKomponen />} />
          </Route>
          {/* /// activity */}
          {/* // | list activity */}
          <Route exact path="/dataactivity" element={<PrivateRoute />}>
            <Route exact path="/dataactivity" element={<ListActivity />} />
          </Route>
          {/* // | add activity */}
          <Route exact path="/addactivity" element={<PrivateRoute />}>
            <Route exact path="/addactivity" element={<AddActivity />} />
          </Route>
          {/* /// pre-activity */}
          {/* // | list pre-activity */}
          <Route exact path="/datapreactivity" element={<PrivateRoute />}>
            <Route exact path="/datapreactivity" element={<ListPreActivity />} />
          </Route>
          {/* // | add pre activity */}
          <Route exact path="/addpreactivity" element={<PrivateRoute />}>
            <Route exact path="/addpreactivity" element={<AddPreActivity />} />
          </Route>
          {/* /// checklist */}
          {/* // | list checklist */}
          <Route exact path="/datachecklist" element={<PrivateRoute />}>
            <Route exact path="/datachecklist" element={<ListChecklist />} />
          </Route>
          {/* /// Report */}
          {/* // | report data produksi plant 3 */}
          <Route exact path="/dataproduksi3" element={<PrivateRoute />}>
            <Route exact path="/dataproduksi3" element={<Dataproduksi />} />
          </Route>
          {/* /// page notfound handler */}
          {/* // | page not found */}
          <Route path="*" element={<NotfountPage />} />
          {/* <Route exact path="/dashboard" element={<DashboardPage />} /> */}
        </Routes>
      </div>
    );
  }
}

export default App;
