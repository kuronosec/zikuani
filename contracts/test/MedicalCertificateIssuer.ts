import { ethers } from "hardhat";
import { expect } from "chai";

describe("MedicalCertificateIssuer", function () {
  it("stores requests and responses", async function () {
    const [owner, government] = await ethers.getSigners();
    const IssuerMock = await ethers.getContractFactory("ZKFirmaDigitalCredentialIssuerMock");
    const issuer = await IssuerMock.deploy();

    await issuer.setIds([1]);

    const Contract = await ethers.getContractFactory("MedicalCertificateIssuer");
    const med = await Contract.deploy(await issuer.getAddress(), government.address);

    const reqNum = ethers.encodeBytes32String("REQ");
    await med.requestMedicalCertificate(BigInt(owner.address), reqNum);

    expect(await med.getUserRequestCount(BigInt(owner.address))).to.equal(1n);

    const respHash = ethers.encodeBytes32String("HASH");
    const aes = ethers.encodeBytes32String("AES");
    await med.connect(government).respondMedicalCertificateRequest(BigInt(owner.address), respHash, aes);

    expect(await med.getUserRequestCount(BigInt(owner.address))).to.equal(0n);
    expect(await med.getGovernmentReponseCount(BigInt(owner.address))).to.equal(1n);
  });
});
