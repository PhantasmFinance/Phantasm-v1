import React, { useEffect, useState } from "react";
import TradingViewWidget, { Themes } from 'react-tradingview-widget';
import { Form,  Button, List } from "antd";
import { Card} from 'antd';
import { Slider, Avatar, Input, Space } from 'antd';
import "./Dashboard.scss"
import { Select } from 'antd';
import Bonds from "./Bonds";


function handleChange(value) {
  console.log(`selected ${value}`);
}

export default function Dashboard(){ 

  const [isLong, setIsLong] = useState(true);
  const [leverage, setLeverage] = useState(5);
  const [symbol, setSymbol] = useState("ETHDAI");
  const [currentValue, setCurrentValue] = useState(0)
  const bondInfo = ['month 1', 'month 2', 'month 3'];




  return (
    
    <div class="mainpage">
      <main class="dashboard">
        
        <div class="market-container">

            <div class="sidebar">
                <div>
                  <Select className="select" style={{ backgroundColor: "#a17fe0", marginBottom: "20px"}} defaultValue="Asset 1" onChange={handleChange}>
                  </Select>

                  <Select className="select" style={{ backgroundColor: "#a17fe0" ,marginBottom: "50px" }} defaultValue="Asset 2" onChange={handleChange}>
                  </Select>                  
                </div>
                <Form
                    layout="vertical"
                    autoComplete="off"
                    class="form"
                >
                    <div style={{ overflow: 'hidden', width: "500px" }}>
                      <Form.Item
                        label="Collateral"
                      >
                        <Input placeholder="Collateral" />
                      </Form.Item>
                    </div>
                </Form>

                  <div className="long-short-box">
                    <Button
                      type="text"
                      shape="round"
                      style={{
                        background: isLong ? "#28A644" : "#FFFFFF",
                        color: isLong ? "#FFFFFF" : "#000000",
                        borderRadius: "25px 0px 0px 25px",
                        border: "1px solid #E5E5E5",
                        borderRight: "none",
                        boxShadow: "none",
                        flexGrow: 1,
                      }}
                      onClick={() => setIsLong(true)}
                    >
                      Long
                    </Button>
                    <Button
                      type="text"
                      shape="round"
                      style={{
                        background: isLong ? "#FFFFFF" : "#E54848",
                        color: isLong ? "#000000" : "#FFFFFF",
                        borderRadius: "0px 25px 25px 0px",
                        border: "1px solid #E5E5E5",
                        borderLeft: "none",
                        boxShadow: "none",
                        flexGrow: 1
                      }}
                      onClick={() => setIsLong(false)}
                    >
                      Short
                    </Button>
                  </div>

                  <Form>
                    <div class="slider-box">
                      <p>
                        Leverage:   { currentValue}x
                      </p>  
                                          
                      <Slider 
                          defaultValue={0} 
                          disabled={false} 
                          trackStyle={{ backgroundColor: "green" }}
                          handleStyle={{ borderColor:"green" }}   
                          max={10} 
                          onChange={(value)=> { setCurrentValue(value)}}
                      />

                    </div>
                    <Form.Item>
        
                    </Form.Item>
                    <Form.Item>
                      <div className="submit-box">
                      <Button
                        type="primary"
                        htmlType="submit"
                        size="large"
                        style={{
                          background:"#28A644",
                          boxShadow: "none",
                          width: 500,
                          borderRadius: "10px"                
                        }}
                      >
                        Submit
                      </Button>
                      </div>
                    </Form.Item>
                </Form>
            </div>     
            <TradingViewWidget
                  symbol="ETHUSD"
                  theme={Themes.DARK}
                  locale="en"
                  autosize
            />             
        </div>

        <h1 align="center" class="bonds" >Available Bonds</h1>


        <div class="horizontal-cards">
           {bondInfo.map(month => <Bonds> {bondInfo}</Bonds>)}           
        </div>
      </main>

      <footer class="site-footer">
           <div className="footer-copyright">&copy; 2021 Phantasm Finance</div>
      </footer>

    </div>
  );
}
