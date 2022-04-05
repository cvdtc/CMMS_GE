import React, { Component } from "react";
import "./sidebar.css";
import { menu } from "../menu";

class Sidebar extends Component {
  render() {
    return (
      <div className="sidebar-bg">
        <div className="sidebar">
          <div className="sidebarlist">
            <ul>
              {menu.map((val, key) => {
                return (
                  <li
                    key={key}
                    className="row"
                    id={window.location.pathname === val.link ? "active" : ""}
                    onClick={() => {
                      window.location.pathname = val.link;
                    }}
                  >
                    {/* {" "} */}
                    <div id="icon">{val.icon}</div>{" "}
                    <div id="title">{val.title}</div>
                  </li>
                );
              })}
            </ul>
          </div>
        </div>
      </div>
    );
  }
}

export default Sidebar;
