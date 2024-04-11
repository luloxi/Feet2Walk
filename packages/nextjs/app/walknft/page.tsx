"use client";

import Image from "next/image";
import type { NextPage } from "next";
import { formatEther } from "viem";
import { useAccount } from "wagmi";
import { useDeployedContractInfo, useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

const Home: NextPage = () => {
  const { address } = useAccount();

  const { data: feetCoordinatorData } = useDeployedContractInfo("FeetCoordinator");

  const { data: costPerToken } = useScaffoldContractRead({
    contractName: "FeetCoordinator",
    functionName: "getCostPerToken",
  });

  const { data: tokenBalance } = useScaffoldContractRead({
    contractName: "FeetToken",
    functionName: "balanceOf",
    args: [address],
  });

  const { writeAsync: goWalk } = useScaffoldContractWrite({
    contractName: "FeetCoordinator",
    functionName: "goWalk",
  });

  const { writeAsync: approve } = useScaffoldContractWrite({
    contractName: "FeetToken",
    functionName: "approve",
    args: [feetCoordinatorData?.address, BigInt(2)],
  });

  return (
    <>
      <div className="hero" style={{ backgroundImage: "url(/feet-horizontal.jpg)" }}>
        <div className="hero-overlay bg-opacity-60"></div>
        <div className="hero-content text-center text-neutral-content">
          <div className="max-w-md">
            <h1 className="mb-5 text-5xl font-bold">Go for a Walk NFT!</h1>
            <p className="mb-5 text-lg bg-slate-200">
              Minted by paying with <strong>2 $FEET tokens</strong>.
              <br />
              After some time, Walk NFTs <strong>can be burnt to decrease the $FEET token price</strong>.
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
            <Image src="/feet-walking.jpg" alt="feet!" />
          </figure>
          <div className="card-body">
            <h2 className="card-title">Go for a Walk NFT!</h2>
            <p>
              It takes 2 $FEET to go for a Walk!
              <br />
              You hold <strong>{tokenBalance?.toString()} $FEET</strong>
            </p>

            <div className="card-actions justify-end">
              <button
                className="btn btn-secondary bg-orange-700"
                onClick={() => {
                  approve();
                }}
              >
                Approve 2 $FEET
              </button>
              <button
                className="btn btn-primary"
                onClick={() => {
                  goWalk();
                }}
              >
                Mint Walk NFT
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;
