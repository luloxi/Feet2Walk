"use client";

import { useState } from "react";
import type { NextPage } from "next";
import { formatEther } from "viem";
import { useAccount } from "wagmi";
import { InputBase } from "~~/components/scaffold-eth";
import { useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const [tokenAmount, setTokenAmount] = useState(0);

  const { address } = useAccount();

  const { data: costPerToken } = useScaffoldContractRead({
    contractName: "FeetCoordinator",
    functionName: "getCostPerToken",
  });

  const { data: tokenBalance } = useScaffoldContractRead({
    contractName: "FeetToken",
    functionName: "balanceOf",
    args: [address],
  });

  const weiValue = costPerToken ? BigInt(tokenAmount) * costPerToken : BigInt(0);

  const { writeAsync: buyTokens } = useScaffoldContractWrite({
    contractName: "FeetCoordinator",
    functionName: "buyTokens",
    args: [BigInt(tokenAmount)],
    value: weiValue,
  });

  return (
    <>
      <div className="hero " style={{ backgroundImage: "url(/feet-banner.jpg)" }}>
        <div className="hero-overlay bg-opacity-60"></div>
        <div className="hero-content text-center text-neutral-content">
          <div className="max-w-md">
            <h1 className="mb-5 text-5xl font-bold">Get some $FEET!</h1>
            <p className="mb-5 text-lg bg-slate-200">
              $FEET token <strong>price increases as the supply increases</strong>
              <br />
              and it&apos;s decreased by each <strong>Walk NFT burn</strong>!
            </p>
          </div>
        </div>
      </div>

      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="card w-96 glass">
          <div className="card-body">
            <h2 className="card-title justify-center text-center">
              Current price per $FEET:
              <br /> {costPerToken ? formatEther(costPerToken) + " ETH" : "Loading..."}
            </h2>
          </div>
        </div>
      </div>

      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="card w-96 glass">
          <figure>
            <img src="https://draxe.com/wp-content/uploads/2021/07/DrAxeHotFeetHeader.jpg" alt="feet!" />
          </figure>
          <div className="card-body">
            <h2 className="card-title">Get your $FEET ready!</h2>
            <p>Soon you&apos;ll know ALL the wonderful things you can do with your $FEET!</p>

            <p>
              You hold {tokenBalance?.toString()} $FEET
              <br />
              Current price per $FEET: {costPerToken ? formatEther(costPerToken) + " ETH" : "Loading..."}
            </p>

            <InputBase placeholder={"How many $FEET do you need?"} value={tokenAmount} onChange={setTokenAmount} />
            <div className="card-actions justify-end">
              <button className="btn btn-primary bg-green-700 border-green-600" onClick={() => buyTokens()}>
                Buy {tokenAmount} $FEET
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;
