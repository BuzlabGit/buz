
const Tokens = artifacts.require("BuzLab");

module.exports = async function(deployer) {
  await deployer.deploy(Tokens);
};
