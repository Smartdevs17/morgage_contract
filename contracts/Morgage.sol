// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "hardhat/console.sol";
contract Morgage {
    address public lender;
    address public borrower;
    uint256 public loanAmount;
    uint256 public interestRate; // Annual interest rate in percentage
    uint256 public loanTerm; // Loan term in months
    uint256 public monthlyPayment;
    uint256 public balance;
    uint256 public startTime;

    event MortgageCreated(address borrower, uint256 loanAmount, uint256 interestRate, uint256 loanTerm);
    event PaymentMade(address borrower, uint256 amount, uint256 balance);
    event LoanDetailsUpdated(uint256 newLoanAmount, uint256 newInterestRate, uint256 newLoanTerm);
    constructor(
        address _borrower,
        uint256 _loanAmount,
        uint256 _interestRate,
        uint256 _loanTerm
    ) {
        lender = msg.sender;
        borrower = _borrower;
        loanAmount = _loanAmount;
        interestRate = _interestRate;
        loanTerm = _loanTerm;
        balance = _loanAmount;
        startTime = block.timestamp;
        monthlyPayment = calculateMonthlyPayment(_loanAmount, _interestRate, _loanTerm);

        emit MortgageCreated(_borrower, _loanAmount, _interestRate, _loanTerm);
    }

    function calculateMonthlyPayment(
        uint256 _loanAmount,
        uint256 _interestRate,
        uint256 _loanTerm
    ) public pure returns (uint256) {
        require(_interestRate > 0, "Interest rate must be greater than 0");
        require(_loanTerm > 0, "Loan term must be greater than 0");

        // Convert annual interest rate to a monthly rate (in percentage)
        uint256 monthlyRate = _interestRate / 12;

        // Convert percentage to a decimal
        uint256 monthlyRateDecimal = monthlyRate / 100;

        // Calculate the numerator and denominator for the monthly payment formula
        uint256 numerator = _loanAmount * monthlyRateDecimal;
        uint256 denominator = 1 - (1 / ((1 + monthlyRateDecimal) ** _loanTerm));
 

        // Avoid division by zero
        require(denominator > 0, "Denominator must be greater than 0");

        return numerator / denominator;
    }

    function makePayment() public payable {
        require(msg.sender == borrower, "Only the borrower can make payments");
        require(msg.value == monthlyPayment, "Incorrect payment amount");

        balance -= msg.value;
        emit PaymentMade(borrower, msg.value, balance);
    }

    function getBalance() public view returns (uint256) {
        return balance;
    }

    function getMonthlyPayment() public view returns (uint256) {
        return monthlyPayment;
    }

    function getRemainingTerm() public view returns (uint256) {
        uint256 monthsElapsed = (block.timestamp - startTime) / 30 days;
        return loanTerm > monthsElapsed ? loanTerm - monthsElapsed : 0;
    }

    function getLoanDetails() public view returns (
        address _lender,
        address _borrower,
        uint256 _loanAmount,
        uint256 _interestRate,
        uint256 _loanTerm,
        uint256 _monthlyPayment,
        uint256 _balance,
        uint256 _startTime
    ) {
        _lender = lender;
        _borrower = borrower;
        _loanAmount = loanAmount;
        _interestRate = interestRate;
        _loanTerm = loanTerm;
        _monthlyPayment = monthlyPayment;
        _balance = balance;
        _startTime = startTime;
    }

 
}
