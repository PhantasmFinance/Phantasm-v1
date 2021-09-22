import React from "react";
import "./WalletButton.scss";

export default function WalletButton({
  provider,
  loadWeb3Modal,
  logoutOfWeb3Modal
}) {
  return (
    <button
      className="wallet-button"
      onClick={() => {
        console.log({ provider });
        if (!provider) {
          loadWeb3Modal();
        } else {
          logoutOfWeb3Modal();
        }
      }}
    >
      {!provider ? "Connect Wallet" : "Disconnect Wallet"}
    </button>
  );
}
