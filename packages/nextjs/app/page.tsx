"use client";

import type { NextPage } from "next";

const Home: NextPage = () => {
  return (
    <>
      <div className="hero min-h-screen" style={{ backgroundImage: "url(/feet-hero.jpg)" }}>
        <div className="hero-overlay bg-opacity-60"></div>
        <div className="hero-content text-center text-neutral-content">
          <div className="max-w-md">
            <h1 className="mb-5 text-5xl font-bold">Hello feet lover!</h1>
            <p className="mb-5 text-lg">
              It doesn&apos;t matter why you love feet. <strong>We all do!</strong>
              <br />
              <strong>Express your love for feet</strong> with your crypto!
            </p>
            <div className="flex flex-row justify-center gap-3">
              <button className="btn btn-primary">Get some $FEET</button>
              <button className="btn btn-secondary">Go for a Walk NFT</button>
            </div>
          </div>
        </div>
      </div>

      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="card w-96 glass">
          <figure>
            <img src="https://draxe.com/wp-content/uploads/2021/07/DrAxeHotFeetHeader.jpg" alt="car!" />
          </figure>
          <div className="card-body">
            <h2 className="card-title">Get your $FEET ready!</h2>
            <p>How much $FEET do you want to buy?</p>
            <div className="card-actions justify-end">
              <button className="btn btn-primary">Learn now!</button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;
