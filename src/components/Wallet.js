import React from "react";
import { WalletButton } from "./";
import walletImg from "../assets/wallet.png";

export default function NoWallet() {
  return (
    <div className="no-wallet-warning">
      <img alt="wallet" src={walletImg} />
      <h2>No Wallet Connected</h2>
      <WalletButton/>
    </div>
  );
}
