// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract Casino {
    enum RedBlack {BLACK, RED}
    mapping(address => uint256) public rougenoirAmount;
    mapping(address => RedBlack) public rougenoirBet;
    mapping(address => uint256) public rougenoirBlockHeight;
    event GameResult(address indexed player, uint256 betAmount, bool won);
    constructor() payable {

    }

    function setRougeNoir(uint8 bet) public payable returns (bool) {
        require(rougenoirBlockHeight[msg.sender] == 0, "Finish your running game first!");
        RedBlack playerBet = RedBlack(bet);

        rougenoirBlockHeight[msg.sender] = block.number + 2;
        rougenoirAmount[msg.sender] = msg.value;
        rougenoirBet[msg.sender] = playerBet;
        return true;
    }

    function getRougeNoirResult() public returns (bool) {
        require(blockhash(rougenoirBlockHeight[msg.sender]) != 0, "Please make a bet first");
        uint256 blockHash = uint256(blockhash(rougenoirBlockHeight[msg.sender]));
        RedBlack playerBet = rougenoirBet[msg.sender];
        RedBlack gameResult = RedBlack(blockHash % 2);

        if (gameResult == playerBet) {
            uint256 payout = rougenoirAmount[msg.sender] * 2;
            emit GameResult(msg.sender, payout, true);
            (bool success, ) = msg.sender.call{value: payout}("");
            return success;
        } else {
            emit GameResult(msg.sender, 0, false);
        }
        resetRougeNoirGame();
        return false;
    }

    function getContractFunds() external view returns(uint256){
        return address(this).balance;
    }


    function resetRougeNoirGame() internal {
        rougenoirAmount[msg.sender] = 0;
        rougenoirBlockHeight[msg.sender] = 0;
    }
}