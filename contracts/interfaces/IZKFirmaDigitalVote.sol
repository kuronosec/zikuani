// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

interface IZKFirmaDigitalVote {

    struct Proposal {
        string description;
        uint256 voteCount;
    }

    struct UserData {
        uint256 nullifier;
        uint256 citizenship;
        uint256 identityCreationTimestamp;
    }

    event Voted(address indexed _from, uint256 indexed _propositionIndex);
}
