import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import './index.css'

// * customized
/// import css bootstrap
import "bootstrap/dist/css/bootstrap.min.css";
/// import browser router from react router dom
import { BrowserRouter } from "react-router-dom";

ReactDOM.render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>,
  document.getElementById("root")
);
