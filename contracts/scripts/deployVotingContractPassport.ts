import '@nomiclabs/hardhat-ethers'
import { ethers } from 'hardhat'

async function main() {

  const verifierAddress = "0x5E49605FDC07F853b3f03b51e687A04e89B29cdF";
  const registrationSMTAddress = "0x85e46721ED2eC04cc9Dfd02C385307cDa0133c32";
  
  // Example timestamp upper bound (e.g., current time + 1 month)
  const identityCreationTimestampUpperBound = Math.floor(Date.now() / 1000) + 30 * 24 * 60 * 60;
  console.log("identityCreationTimestampUpperBound: ", identityCreationTimestampUpperBound);

  // TODO: how does it work?
  const citizenshipWhitelist = [0x435249, 0x434f4c];

  // Example birth date lower bound (e.g., 18 years ago)
  const birthDateLowerbound = Math.floor(Date.now() / 1000) - 18 * 365 * 24 * 60 * 60;
  console.log("birthDateLowerbound: ", birthDateLowerbound);

  // Example expiration date lower bound (e.g., must expire after 2026)
  const expirationDateLowerBound = Math.floor(new Date("2026-01-01").getTime() / 1000);
  console.log("expirationDateLowerBound: ", expirationDateLowerBound);

  const voteScope = Math.floor(Math.random() * 100000);

  console.log(`verifier contract deployed to ${verifierAddress}`);

  const ZKPassportVote = await ethers.deployContract('ZKPassportVote', [
    "¿Está usted de acuerdo con que se apruebe la LEY DE MERCADO DE CRIPTOACTIVOS en Costa Rica?",
    ["Sí, estoy de acuerdo.", "No, no estoy de acuerdo."],
    identityCreationTimestampUpperBound,
    citizenshipWhitelist,
    birthDateLowerbound,
    expirationDateLowerBound,
    voteScope,
    registrationSMTAddress,
    verifierAddress,
  ]);

  await ZKPassportVote.waitForDeployment()

  console.log(
    `ZKPassportVote contract deployed to ${await ZKPassportVote.getAddress()}`,
  );
}

main().catch(error => {
  console.error(error);
  process.exitCode = 1;
})