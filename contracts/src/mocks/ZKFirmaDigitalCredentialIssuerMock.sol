// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IZKFirmaDigitalCredentialIssuer} from "../../interfaces/IZKFirmaDigitalCredentialIssuer.sol";
import {INonMerklizedIssuer} from "@iden3/contracts/interfaces/INonMerklizedIssuer.sol";

contract ZKFirmaDigitalCredentialIssuerMock is IZKFirmaDigitalCredentialIssuer {
    uint256[] private _ids;
    struct Issued {
        uint256 userId;
        uint256 nullifierSeed;
        uint256 nullifier;
        uint256 signal;
        uint256 reveal;
    }
    Issued public lastIssued;

    function setIds(uint256[] calldata ids) external {
        _ids = ids;
    }

    function getUserCredentialIds(uint256) external view override returns (uint256[] memory) {
        return _ids;
    }

    function getCredential(uint256, uint256) external pure override returns (
        INonMerklizedIssuer.CredentialData memory,
        uint256[8] memory,
        INonMerklizedIssuer.SubjectField[] memory
    ) {
        INonMerklizedIssuer.CredentialData memory cd;
        uint256[8] memory proof;
        INonMerklizedIssuer.SubjectField[] memory fields;
        return (cd, proof, fields);
    }

    function revokeClaimAndTransit(uint64) external override {}

    function issueCredential(
        uint _userId,
        uint nullifierSeed,
        uint nullifier,
        uint signal,
        uint[1] calldata revealArray,
        uint[8] calldata /*groth16Proof*/
    ) external override {
        lastIssued = Issued({
            userId: _userId,
            nullifierSeed: nullifierSeed,
            nullifier: nullifier,
            signal: signal,
            reveal: revealArray[0]
        });
    }
}
