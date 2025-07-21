import { ethers } from "hardhat";
import { expect } from "chai";

describe("ZKFirmaDigitalVote", function () {
  it("records a vote and issues credential", async function () {
    const [owner] = await ethers.getSigners();
    const IssuerMock = await ethers.getContractFactory("ZKFirmaDigitalCredentialIssuerMock");
    const issuer = await IssuerMock.deploy();

    const proposals = ["Yes", "No"];
    const Vote = await ethers.getContractFactory("ZKFirmaDigitalVote");
    const vote = await Vote.deploy("Q?", proposals, await issuer.getAddress(), 5);

    const proof = Array(8).fill(0);
    await vote.voteForProposal(0, 5, 100, owner.address, [1], proof);

    const stored = await issuer.lastIssued();
    expect(stored.userId).to.equal(BigInt(owner.address));
    expect(stored.nullifierSeed).to.equal(5n);
    expect(stored.nullifier).to.equal(100n);
    expect(stored.signal).to.equal(BigInt(owner.address));

    const totalVotes = await vote.getTotalVotes();
    expect(totalVotes).to.equal(1n);

    await expect(
      vote.voteForProposal(0, 5, 100, owner.address, [1], proof)
    ).to.be.revertedWith("[ZKFirmaDigitalVote]: User has already voted");
  });
});
