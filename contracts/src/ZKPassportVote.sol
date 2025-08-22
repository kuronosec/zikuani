// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import '../interfaces/IZKFirmaDigitalVote.sol';

import {IPoseidonSMT} from "@rarimo/passport-contracts/interfaces/state/IPoseidonSMT.sol";
import {PublicSignalsBuilder} from "@rarimo/passport-contracts/sdk/lib/PublicSignalsBuilder.sol";
import {AQueryProofExecutor} from "@rarimo/passport-contracts/sdk/AQueryProofExecutor.sol";

contract ZKPassportVote is IZKFirmaDigitalVote, AQueryProofExecutor {
    string public votingQuestion;
    // A random number to use as nullifier seed.
    // We need a different number for each vote contract to avoid double voting
    uint64 public voteScope;

    // List of proposals
    Proposal[] public proposals;

    uint256 selector;
    // Voting restrictions
    uint256 identityCreationTimestampUpperBound;
    uint256[] citizenshipWhitelist;
    uint256 birthDateLowerbound;
    uint256 expirationDateLowerBound;

    // Mapping to track if a userNullifier has already voted
    mapping(uint256 => bool) public hasVoted;
    
    // PublicSignalsBuilder is a library for building public signals
    using PublicSignalsBuilder for uint256;

    uint256 public constant IDENTITY_LIMIT = type(uint32).max;

    // Constructor to initialize proposals
    constructor(
        string memory _votingQuestion,
        string[] memory _proposalDescriptions,
        uint256 _identityCreationTimestampUpperBound,
        uint256[] memory _citizenshipWhitelist,
        uint256 _birthDateLowerbound,
        uint256 _expirationDateLowerBound,
        uint64 _voteScope,
        address _registrationSMT,
        address _verifier
    ) {
        votingQuestion = _votingQuestion;
        identityCreationTimestampUpperBound = _identityCreationTimestampUpperBound;
        citizenshipWhitelist = _citizenshipWhitelist;
        birthDateLowerbound = _birthDateLowerbound;
        expirationDateLowerBound = _expirationDateLowerBound;
        for (uint256 i = 0; i < _proposalDescriptions.length; i++) {
            proposals.push(Proposal(_proposalDescriptions[i], 0));
        }
        voteScope = _voteScope;
        __AQueryProofExecutor_init(_registrationSMT, _verifier);
    }

    function _beforeVerify(bytes32, uint256, bytes memory _userPayload) internal view override {
        (uint256 proposalIndex, UserData memory _userData) = abi.decode(
            _userPayload,
            (uint256, UserData)
        );

        require(
            proposalIndex < proposals.length,
            '[ZKPassportVote]: Invalid proposal index'
        );
        // Check that user hasn't already voted
        require(
            !checkVoted(_userData.nullifier),
            '[ZKPassportVote]: User has already voted'
        );
        // Check for a predefined list of countires to be able to vote
        require(
            _validateCitizenship(citizenshipWhitelist, _userData.citizenship),
            "Voting: citizenship is not whitelisted"
        );
    }

    function _afterVerify(bytes32, uint256, bytes memory _userPayload) internal override {
        (uint256 proposalIndex, UserData memory _userData) = abi.decode(
            _userPayload,
            (uint256, UserData)
        );

        proposals[proposalIndex].voteCount++;
        hasVoted[_userData.nullifier] = true;

        emit Voted(msg.sender, proposalIndex);
    }

    function _buildPublicSignals(bytes32, uint256 _currentDate, bytes memory _userPayload)
        internal view override returns (uint256) {
        (uint256 proposalIndex, UserData memory _userData) = abi.decode(
            _userPayload,
            (uint256, UserData)
        );

        // Limit of time for creation of identity
        uint256 _identityCreationTimestampUpperBound = identityCreationTimestampUpperBound -
            IPoseidonSMT(getRegistrationSMT()).ROOT_VALIDITY();
        uint256 identityCounterUpperBound = IDENTITY_LIMIT;

        // Limit of number of identities created
        if (_userData.identityCreationTimestamp > 0) {
            _identityCreationTimestampUpperBound = _userData.identityCreationTimestamp;
            identityCounterUpperBound = identityCounterUpperBound;
        }

        uint256 builder = PublicSignalsBuilder.newPublicSignalsBuilder(
            selector,
            _userData.nullifier
        );
        builder.withCurrentDate(_currentDate, 1 days);
        builder.withEventIdAndData(
            voteScope,
            uint256(uint248(uint256(keccak256(abi.encode(proposalIndex)))))
        );
        builder.withCitizenship(_userData.citizenship);
        builder.withTimestampLowerboundAndUpperbound(0,
            _identityCreationTimestampUpperBound);
        builder.withIdentityCounterLowerbound(0,
            identityCounterUpperBound);
        builder.withBirthDateLowerboundAndUpperbound(
            birthDateLowerbound,
            PublicSignalsBuilder.ZERO_DATE
        );
        builder.withExpirationDateLowerboundAndUpperbound(
            expirationDateLowerBound,
            PublicSignalsBuilder.ZERO_DATE
        );

        return builder;
    }

    // Function to get the total number of proposals
    function getProposalCount() public view returns (uint256) {
        return proposals.length;
    }

    // Function to get the total number of votes across all proposals
    function getTotalVotes() public view returns (uint256) {
        uint256 totalVotes = 0;
        uint256 proposalLength = proposals.length;
        for (uint256 i = 0; i < proposalLength; i++) {
            totalVotes += proposals[i].voteCount;
        }
        return totalVotes;
    }

    // Function to check if a user has already voted
    function checkVoted(uint256 _nullifier) public view returns (bool) {
        return hasVoted[_nullifier];
    }

    function _validateCitizenship(
        uint256[] memory whitelist_,
        uint256 elem_
    ) internal pure returns (bool) {
        if (whitelist_.length == 0) {
            return true;
        }

        for (uint256 i = 0; i < whitelist_.length; ++i) {
            if (whitelist_[i] == elem_) {
                return true;
            }
        }

        return false;
    }
}