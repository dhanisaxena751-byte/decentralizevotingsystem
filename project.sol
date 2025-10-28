// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Project {
    address public admin;
    bool public votingActive;

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    constructor() {
        admin = msg.sender;
        votingActive = true;
    }

    // Add a candidate (admin only)
    function addCandidate(string memory _name) external {
        require(msg.sender == admin, "Only admin can add candidates");
        require(votingActive, "Voting period has ended");
        candidates.push(Candidate(_name, 0));
    }

    // Cast a vote
    function vote(uint256 candidateIndex) external {
        require(votingActive, "Voting is not active");
        require(!hasVoted[msg.sender], "You have already voted");
        require(candidateIndex < candidates.length, "Invalid candidate index");

        candidates[candidateIndex].voteCount += 1;
        hasVoted[msg.sender] = true;
    }

    // End voting and announce winner
    function getWinner() external view returns (string memory winnerName, uint256 winnerVotes) {
        require(candidates.length > 0, "No candidates available");

        uint256 highestVotes = 0;
        uint256 winnerIndex = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }

        return (candidates[winnerIndex].name, candidates[winnerIndex].voteCount);
    }

    // Optional: admin can close voting
    function closeVoting() external {
        require(msg.sender == admin, "Only admin can close voting");
        votingActive = false;
    }
}
