// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {

    address payable[] public players;
    address public manager;

    constructor() {
        manager = msg.sender;
    }

    // Allow anyone to send Ether, as long as it's 1 Ether or more
    receive() payable external {
        require(msg.value >= 1 ether, "Minimum amount is 1 Ether");
        players.push(payable(msg.sender)); // Add player to the array
    }

    function getBalance() public view returns (uint) {
        require(msg.sender == manager, "You are not the manager");
        return address(this).balance;
    }

    function random() internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(msg.sender == manager);
        require(players.length >= 3);

        uint r = random();
        address payable winner;

        uint index = r % players.length;

        winner = players[index];

        // Transfer the entire balance to the winner and reset the players array
        winner.transfer(address(this).balance);
        
        delete players;  // Reset the players array
    }
}
