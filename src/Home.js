import { Box, Text, Heading } from "@chakra-ui/layout";
import { Cards } from "./Cards";
import TradingViewWidget, { Themes } from 'react-tradingview-widget';
import { Dropdown } from "./Dropdown";
import { MainCard } from "./MainCard";
import "./Home.css"

export const Home = () => {
  return (
      <box class="flexbox-container">

      <Dropdown />
      <div class="main">
      <MainCard class="main"/>
      </div>
      <div class='trading'>
        <TradingViewWidget
                    symbol="ETHUSD"
                    theme={Themes.DARK}
                    locale="en"
                    autosize

              />  
        </div>

      </box>
  );
};
