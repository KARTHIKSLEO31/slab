async function deployContract() {
    const CentralToken = await ethers.getContractFactory("CentralToken")
    const centralToken = await CentralToken.deploy()
    await centralToken.deployed()
    const txHash = centralToken.deployTransaction.hash
    const txReceipt = await ethers.provider.waitForTransaction(txHash)
    const contractAddress = txReceipt.contractAddress
    console.log("Contract deployed to address:", contractAddress)
   }
   
  deployContract()
  .then(() => process.exit(0))
  .catch((error) => {
   console.error(error);
   process.exit(1);
  });