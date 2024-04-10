"use client";

import Link from "next/link";
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
              <Link href={"/buytokens"}>
                <button className="btn btn-primary">Get some $FEET</button>
              </Link>
              <Link href={"/walknft"}>
                <button className="btn btn-secondary">Go for a Walk NFT</button>
              </Link>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;
