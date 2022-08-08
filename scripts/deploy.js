const { ethers } = require("hardhat");

async function main() {
  const BankFactory = await ethers.getContractFactory("Bank");
  const bank = await BankFactory.deploy();
  await bank.deployed();

  console.log(`Deployed contract to ${bank.address}`);

  console.log(`Account balance: ${await bank.getAccountBalance()}`);

  console.log("**************************************************************");

  console.log("Depositing eth...................................");
  const options = { value: ethers.utils.parseEther("0.0001") };

  //deposit 100 wei
  const TXreponse = await bank.deposit(options);

  console.log(await TXreponse.wait(1));

  console.log("**************************************************************");

  //get balance
  console.log(`New account balance: ${await bank.getAccountBalance()}`);

  console.log("**************************************************************");

  //   //Withdraw funds
  const Withresponse = await bank.withdrawEth(5e13);
  //console.log(await Withresponse.wait(1));

  console.log("**************************************************************");

  //   //get balance
  console.log(`New account balance: ${await bank.getAccountBalance()}`);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
