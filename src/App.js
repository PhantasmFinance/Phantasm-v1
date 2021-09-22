import React, { useState, useEffect } from "react";
import { BrowserRouter as Router, Route } from "react-router-dom";
import { Contract } from "@ethersproject/contracts";
// import { getDefaultProvider } from "@ethersproject/providers";
import useWeb3Modal from "./hooks/useWeb3Modal";
import  Header  from "./components/Header";

import "./App.scss";
import "antd/dist/antd.css";  

const targetNetwork = "Mainnet";
var contractAddress="";
const abi="";

function App() {
  const [provider, loadWeb3Modal, logoutOfWeb3Modal] = useWeb3Modal();
  const [userAddress, setUserAddress] = useState(null);
  const [network, setNetwork] = useState(null);
  const [perpetualContract, setPerpetualContract] = useState();


  useEffect(() => {
    let subscribed = true;

    if (provider) {
      setPerpetualContract(
        new Contract(contractAddress, abi, provider.getSigner())
      );
      provider
        .getNetwork()
        .then(result => {
          if (subscribed) {
            setNetwork(result);
          }
        })
        .catch(err => {
          console.log(err);
        });
    }

    return () => {
      subscribed = false;
    };
  }, [provider]);

  useEffect(() => {
    const signer = provider?.getSigner();
    if (signer) {
      if (perpetualContract) {
        setPerpetualContract(perpetualContract.connect(signer));
      }

      signer
        .getAddress()
        .then(address => {
          setUserAddress(address);
        })
        .catch(err => {
          console.log("Couldn't get signer", err);
        });
    }
  }, [provider]);

  return (
    <div className="app">
      <Router>
        <Route path="/" exact>
          <Header
            address={userAddress}
            provider={provider}
            loadWeb3Modal={loadWeb3Modal}
            logoutOfWeb3Modal={logoutOfWeb3Modal}
          />
        </Route>
      </Router>
      {network && network.name !== targetNetwork && (
        <div className="modal-container">
          <div className="network-modal">
            <p>Please switch network to {targetNetwork}</p>
          </div>
        </div>
      )}
    </div>
  );
}

// Reload on Network Switch
window.ethereum &&
  window.ethereum.on("chainChanged", () => {
    setTimeout(() => {
      window.location.reload();
    }, 1);
  });

export default App;
