import React, { useEffect, useState } from "react";
import TradingViewWidget, { Themes } from 'react-tradingview-widget';
import { Form,  Button, List } from "antd";
import { Card} from 'antd';
import { Slider, Switch } from 'antd';
import "./Dashboard.scss"
import { Footer } from 'antd/lib/layout/layout';
import { Select } from 'antd';

const { Option } = Select;
const { Meta } = Card;

function handleChange(value) {
  console.log(`selected ${value}`);
}

export default function Dashboard(){ 

  const [isLong, setIsLong] = useState(true);
  const [leverage, setLeverage] = useState(5);
  const [symbol, setSymbol] = useState("ETHDAI");
 
  return (
    
    <div class="mainpage">
      <main class="dashboard">
        
        <div class="market-container">

            <div class="sidebar">
                <div>
                  <Select className="select" style={{ backgroundColor: "#a17fe0" }} placeholder="Asset 1" onChange={handleChange}>
                  </Select>

                  <Select className="select" style={{ backgroundColor: "#a17fe0" }} placeholder="Asset 2" onChange={handleChange}>
                  </Select>                  
                </div>

                <List
                  bordered
                  size="small"
                  style={{ borderRadius: "10px", marginBottom: "30px" , marginTop: "20px", width: "500px"}}
                >
                  <List.Item>
                    <List.Item.Meta title={"Amount"}></List.Item.Meta>
                    <div>{ "-"}</div>    
                  </List.Item>
                  <List.Item>
                    <List.Item.Meta title={"Collateral"}></List.Item.Meta>
                    <div>{ "-"}</div>
                  </List.Item>
                </List>
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
                      flexGrow: 1
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
                  <div>
                    <p>
                      Leverage{" "}
                    </p>
                    <Slider trackStyle={{ backgroundColor: "green" }}
                            handleStyle={{ borderColor:"green" }} 
                            defaultValue={0}
                            min={0}
                            max={10}
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
                        border: "1px solid #E5E5E5",
                        boxShadow: "none",
                        flexGrow: 1,
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

        <div class="cards">

          <Card
              className="card"
              title="88Mph & USDC"
              style={{
                borderRadius: '25px',
                padding: '15px',
                backgroundColor:"#a17fe0",
                borderColor:"#a17fe0"
            }}             

              cover={<img alt="example" class="imginside" src="https://c.gitcoin.co/grants/b497f01f46c8a5ea4d3d1cdbff76348e/Frame_102_jpg.jpg" height="250px" />}
              
          >
            <Meta
                className="Meta"
                title="Card title"
                description="This is the description"
            />
              <div class="card-leverage-slider">
                    <p>
                      Leverage{" "}
                    </p>
                    <Slider trackStyle={{ backgroundColor: "green" }}
                            handleStyle={{ borderColor:"green" }} 
                            defaultValue={0}
                            min={0}
                            max={10}
                    />

              </div>
          </Card>        
           
        </div>
      </main>

      <Footer class="site-footer">
           <div className="footer-copyright">&copy; 2021 Phantasm Finance</div>
      </Footer>

    </div>
  );
}
