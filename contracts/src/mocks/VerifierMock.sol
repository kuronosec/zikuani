// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IZKFirmaDigitalGroth16Verifier} from "../../interfaces/IZKFirmaDigitalGroth16Verifier.sol";

contract VerifierMock is IZKFirmaDigitalGroth16Verifier {
    bool public result = true;
    function setResult(bool _result) external {
        result = _result;
    }
    function verifyProof(
        uint[2] calldata,
        uint[2][2] calldata,
        uint[2] calldata,
        uint[5] calldata
    ) external view override returns (bool) {
        return result;
    }
}
