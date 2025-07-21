import { ethers } from "hardhat";
import { expect } from "chai";

describe("ZKFirmaDigital", function () {
  it("returns verifier result", async function () {
    const VerifierMock = await ethers.getContractFactory("VerifierMock");
    const verifier = await VerifierMock.deploy();
    const ZKFirmaDigital = await ethers.getContractFactory("ZKFirmaDigital");
    const zk = await ZKFirmaDigital.deploy(verifier.getAddress(), 1);

    const proof = Array(8).fill(0);
    expect(
      await zk.verifyZKFirmaDigitalProof(1, 2, 3, [0], proof)
    ).to.equal(true);

    await verifier.setResult(false);
    expect(
      await zk.verifyZKFirmaDigitalProof(1, 2, 3, [0], proof)
    ).to.equal(false);
  });
});
