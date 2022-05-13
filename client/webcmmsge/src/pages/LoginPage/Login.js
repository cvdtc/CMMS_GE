import React, { useState } from "react";

// | import customize css
import "./login.css";
// | import require components
import { useNavigate } from "react-router-dom";
import axios from "../../utils/server";

const LoginPage = () => {
  /// define form state
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  /// form validate
  const [validation, setValidation] = useState([]);
  /// previous page handler
  const history = useNavigate();
  const loginHandler = async (e) => {
    /// event handler
    e.preventDefault();
    /// initialize json value
    const dataLogin = {
      username: username,
      password: password,
      device: "WEBAPI",
      appversion: "3.3",
      uuid: "XXXUUIDWEB202120222023",
    };
    /// sending data json to api
    await axios
      .post("login", dataLogin)
      .then((response) => {
        console.log(response, response.data.data.access_token);
        /// if response  success response code will be store to local storage
        localStorage.setItem("token", response.data.data.access_token);
        localStorage.setItem("username", response.data.data.username);
        localStorage.setItem("jabatan", response.data.data.jabatan);
        /// if logi success will be route to home page
        setValidation("");
        history("/dashboard");
      })
      .catch((error) => {
        /// if response fail will be catch error message
        setValidation(error.response.data);
      });
  };

  return (
    <div className="h-screen flex bg-gray-200">
      <div className="w-full max-w-md m-auto bg-white rounded-md border border-red-500 shadow-md py-10 px-16">
        <img
          alt=""
          src="/assets/logo-ge.png"
          className="w-full"
        />
        <h1 className="text2xl font-medium text-red-700 mt-4 mb-12 text-center">
          LOGIN
        </h1>
        <form onSubmit={loginHandler}>
          {/* input box for username */}
          <div>
            <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="username">Username</label>
            <input className="w-full p-2 text-gray-700 border rounded-md outline-none text-sm transition duration-150 ease-in-out mb-4"
              id="username"
              type="text"
              values={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Username" />
          </div>
          {/* input box for password */}
          <div>
            <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="password">Password</label>
            <input className="w-full p-2 text-gray-700 border rounded-md outline-none text-sm transition duration-150 ease-in-out mb-4"
              id="password"
              type="password"
              values={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="***********" />
          </div>
          {validation.message && (
            <div className="px-4 py-3 leading-normal text-yellow-50 bg-warning rounded-lg" role={alert}>{validation.message}</div>
          )}
          <div className="flex-auto justify-center items-center mt-6">
            <button className="w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-red-700 rounded-lg focus:shadow-outline hover:bg-red-800">LOGIN</button>
          </div>
        </form>
      </div>
      <label>Copyright ©2022</label>
    </div>
    // <div className="body">
    //   <div className="container-bg">
    //     <div className="card">
    //       <div className="container">
    //         <div className="card-body">
    //           <h3 className="fw-bold">LOGIN</h3>
    //           <hr />

    //           <form onSubmit={loginHandler}>
    //             <div className="'mb-3">
    //               <label className="form-label">Username</label>
    //               <input
    //                 type="text"
    //                 className="form-control"
    //                 values={username}
    //                 onChange={(e) => setUsername(e.target.value)}
    //                 placeholder="Username" autoComplete="username"
    //               />
    //             </div>
    //             <br />
    //             <div className="'mb-3">
    //               <label className="form-label">Password</label>
    //               <input
    //                 type="password"
    //                 className="form-control"
    //                 values={password}
    //                 onChange={(e) => setPassword(e.target.value)}
    //                 placeholder="Password"
    //                 autoComplete="current-password"
    //               />
    //             </div>
    //             <br />
    //             {validation.message && (
    //               <div className="alert alert-danger">{validation.message}</div>
    //             )}
    //             <div className="d-grid">
    //               <button type="submit" className="button-10">
    //                 M A S U K
    //               </button>
    //             </div>
    //           </form>
    //         </div>
    //       </div>
    //     </div>
    //   </div>
    // </div>
  );
};

export default LoginPage;
