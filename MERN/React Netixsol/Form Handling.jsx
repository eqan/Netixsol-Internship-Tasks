import React from 'react'
import { useState, useEffect } from "react";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
const inputValue = {
    userName: "",
    password: "",
    email: "",
    confirmPassword: "",
  };
const SimpleFormValidation = () => {
    const [value, setValue] = useState(inputValue);
    const handleChange = (e) => {
        // Value object, key: value
        setValue({ ...value, [e.target.name]: e.target.value });
      };
      
    const handleRegistration = (e)=>{
        e.preventDefault();
        console.log(e)
        if(value.userName === ""){
            toast.error("User Name is required")
        }
        if(value.password === ""){
            toast.error("Password is required")
        }
        if(value.email === ""){
            toast.error("Email is required")
        }
        if(value.password !== value.confirmPassword){
            toast.error("Password and Confirm Password must be same")
        }
        if(value.userName.length < 3 || value.userName.length > 10){
            toast.error("User Name must be between 3 and 10 characters")
        }
    }
    // console.log(value);
  return (
    <>
    <div className=" bg-black">
      <div className="w-full pt-5 ml-5 md:w-[35%] md:mx-auto text-white font-sans font-bold bg-black min-h-screen pl-7 pb-5">
        <div className=" min-h-screen items-center justify-items-start">
          <div className=" row-start-2 text-4xl">
            Register
            <form onSubmit={handleRegistration} >
              <div className=" pr-20">
                <label className="text-sm font-sans font-medium">
                  Username
                </label>
                <input
                  // onChange={(e)=>setName(e.target.value)}
                  type="text"
                  name="userName"
                  // value={userName}
                  onChange={handleChange}
                  placeholder="Write your username"
                  className="w-full bg-black py-3 px-12 border hover: border-gray-500 rounded shadow text-base font-sans"
                />
              </div>
              <div className="pt-2 pr-20">
                <label className="text-sm font-sans font-medium">Email</label>
                <input
                  type="email"
                  name="email"
                //   value={value.email}
                  onChange={handleChange}
                  placeholder="Write your email"
                  className="w-full bg-black py-3 px-12 border hover: border-gray-500 rounded shadow text-base font-sans"
                />
              </div>
              <div className="pt-2 pr-20">
                <label className="text-sm font-sans font-medium">
                  Password
                </label>
                <input
                  type="password"
                  name="password"
                  // value={password}
                  onChange={handleChange}
                  placeholder="Write your password"
                  className=" w-full bg-black py-3 px-12 border hover: border-gray-500 rounded shadow text-base font-sans"
                />
              </div>
              <div className="pt-2 pr-20">
                <label className="text-sm font-sans font-medium">
                  Confirm Password
                </label>
                <input
                  type="password"
                  name="confirmPassword"
                  // value={confirmPassword}
                  onChange={handleChange}
                  placeholder="Write your password"
                  className=" w-full bg-black py-3 px-12 border hover: border-gray-500 rounded shadow text-base font-sans"
                />
              </div>
              <div className="text-sm font-sans font-medium w-full pr-20 pt-2">
                <button
                  type="submit"
                  className="text-center w-full py-4 bg-blue-700 hover:bg-blue-400 rounded-md text-white "
                >
                  Register
                </button>
                <ToastContainer />
              </div>
            </form>
          </div>
        </div>
      </div>
      <div className="banner col-span-8 text-white font-sans font-bold"></div>
    </div>
  </>
  )
}
export default SimpleFormValidation