const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Mortgage Contract", function () {
    let Mortgage: any;
    let mortgage: any;
    let lender: any;
    let borrower: any;
    const loanAmount = ethers.parseEther("100");
    const interestRate = 5000; 
    const loanTerm = 12; // 12 months

    beforeEach(async function () {
        [lender, borrower] = await ethers.getSigners();
        Mortgage = await ethers.getContractFactory("Morgage");
        mortgage = await Mortgage.deploy(borrower.address, loanAmount, interestRate, loanTerm);
    });

    it("should set the correct lender and borrower", async function () {
        expect(await mortgage.lender()).to.equal(lender.address);
        expect(await mortgage.borrower()).to.equal(borrower.address);
    });

    it("should revert with panic code 0x12 when interest rate is zero", async function () {
        await expect(Mortgage.deploy(borrower.address, loanAmount, 0, loanTerm)).to.be.revertedWith("Interest rate must be greater than 0");
    });

    it("should revert with panic code 0x12 when loan term is zero", async function () {
        await expect(Mortgage.deploy(borrower.address, loanAmount, interestRate, 0)).to.be.revertedWith("Loan term must be greater than 0");
    });

    it("should set the correct loan details", async function () {
        expect(await mortgage.loanAmount()).to.equal(loanAmount);
        expect(await mortgage.interestRate()).to.equal(interestRate);
        expect(await mortgage.loanTerm()).to.equal(loanTerm);
    });

});
