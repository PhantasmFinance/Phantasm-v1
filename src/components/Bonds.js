import React, { useEffect, useState, useStyles } from "react";
import { Slider, Avatar, Button, Form, Input } from 'antd';

import { Card} from 'antd';
import "./Dashboard.scss"

export default function Bonds(commonProps) {

    const [currentValue, setCurrentValue] = useState(0)



    return (

        <div class="cards">

          <Card
              className="card"
              title="Insulated Bond"
              style={{
                borderRadius: '25px',
                padding: '15px',
                backgroundColor:"#a17fe0",
                borderColor:"#a17fe0",
                marginRight: '250px'
            }}                           
          >
              <div class="row-card">
                <p class="asset">Asset 1 : {commonProps.Asset1} </p>
                <Avatar className="avatar" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuLT9ecFcwy0ufilD-pm1JmkTuEukFd7zKzQ&usqp=CAU" />
              </div>

              <div class="row-card">
                <p class="asset">Asset 2 : {commonProps.Asset2} </p>
                <Avatar src="https://cryptologos.cc/logos/multi-collateral-dai-dai-logo.png"  className="avatar"/>
              </div>


              <Form
                    layout="horizontal"
                    autoComplete="off"
                    class="form"
                >
                    <div style={{ overflow: 'hidden' }}>
                      <Form.Item
                        label="Collateral" >
                        <Input placeholder={commonProps.Asset1} />
                      </Form.Item>
                    </div>
                </Form>


                <div class="card-leverage-slider">
                    <p style={{fontSize: "20px"}}>
                    Leverage:   { currentValue}x
                    </p>
                    <Slider trackStyle={{ backgroundColor: "purple" }}
                            handleStyle={{ borderColor:"purple" }} 
                            defaultValue={0}
                            min={0}
                            max={10}
                            onChange={(value)=> { setCurrentValue(value)}}

                    />
              </div>                
              <div className="submit-box">
                      <Button
                        type="primary"
                        htmlType="submit"
                        style={{
                          background:"purple",
                          width: "100%",
                          height:"100%",
                          borderRadius: "10px",
                          paddingBottom:"10px"
                        }}
                      >
                        Buy
                      </Button>
                      </div>
          </Card>        
           
        </div>
    );
  }