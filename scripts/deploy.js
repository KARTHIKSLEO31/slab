async function deployContract() {
  const CentralVault = await ethers.getContractFactory("CentralVault")
  const centralVault = await CentralVault.deploy("0x99a89D06e49e2Ea951804681D66933247AD3F079")
  await centralVault.deployed()
  const txHash = centralVault.deployTransaction.hash
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