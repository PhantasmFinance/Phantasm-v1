import React, { useEffect, useState, useStyles } from "react";
import { Slider, Avatar, Input, Space } from 'antd';

import { Card} from 'antd';
import "./Dashboard.scss"

export default function Bonds() {
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
                <p>Asset 1 : {} </p>
              </div>

              <div class="row-card">
                <p>Asset 2 : {} </p>
              </div>
              <div class="card-leverage-slider">
                    <p>
                    Leverage: 
                    </p>
                    <Slider trackStyle={{ backgroundColor: "purple" }}
                            handleStyle={{ borderColor:"purple" }} 
                            defaultValue={0}
                            min={0}
                            max={10}

                    />

              </div>
          </Card>        
           
        </div>
    );
  }