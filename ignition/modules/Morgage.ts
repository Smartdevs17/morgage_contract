// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const MorgageModule = buildModule("MorgageModule", (m) => {
const BorrowerAddress = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
const LoanAmount = 100000000000000000000n
const InterestRate = 5000
const LoanTerm = 12
  const morgage = m.contract("Morgage", [BorrowerAddress, LoanAmount, InterestRate, LoanTerm] );
  return { morgage };
});

export default MorgageModule;
