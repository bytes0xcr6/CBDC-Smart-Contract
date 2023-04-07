// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Created by: Cristian Richarte Gil
contract CBDC is ERC20 {

    address public FED;
    uint256 public interestRates;

    mapping(address => uint8) blackList;
    mapping(address => uint256) stakedTreasuryBonds;
    mapping(address => uint256) bonds;
    mapping(address => uint256) stakedTimeStamp;

    event BlackListUpdated(address criminal, uint8 decision);
    event FEDUpdated(address oldFED, address newFED);
    event supplyIncreased(address FED, uint256 oldSupply, uint256 totalSupply);
    event supplyDecreased(address FED, uint256 oldSupply, uint256 totalSupply);
    event DUSDStaked(address staker, uint256 amount, uint256 stakedTime);
    event DUSDUnstaked(address staker, uint256 amount, uint256 unStakedTime);
    event InterestRatesUpdated(uint256 oldInterestRates, uint256 newInterestRates);
    event interestClaimed(address staker, uint256 reward, uint256 newTotalSupply);

    modifier onlyFED() {
        require(msg.sender == FED, "You aren't the FED");
        _;
    }

    // DigitalUSD - DUSD 
    constructor(string memory _name, string memory _symbol, uint256 _amount) ERC20(_name, _symbol){
        FED = msg.sender;
        _mint(msg.sender, _amount);
    }

    // Function to transfer DUSD if you are not in the blackList
    function transferFrom(address _from, address _to, uint256 _amount) public virtual override returns(bool){
        require(blackList[msg.sender] != 1, "From is Black List");
        require(blackList[_to] != 1, "To is Black List");

        super.transferFrom(_from, _to, _amount);
        return true;
    }

    // Function to add & remove addresses to the blacklist. false => 0 (Unblocked) \ true => 1 (Blocked)
    function manageBlackList(address _criminal, uint8 _decision) external onlyFED {
        require(_decision <= 1, "Invalid decision");

        blackList[_criminal] = _decision;
        emit BlackListUpdated(_criminal, _decision);
    }

    // Function to update the FED address
    function updateFED(address _newFed) external onlyFED{
        require(_newFed != address(0));
        address oldFed = FED;
        FED = _newFed;
        emit FEDUpdated(oldFed, _newFed);
    }

    // Function to print/mint more DUSD supply
    function printMoney(uint256 _amount) external onlyFED {
        uint256 oldSupply = totalSupply();
        _mint(msg.sender, _amount);
        emit supplyIncreased(msg.sender, oldSupply, totalSupply());
    }

    // Function to decrese the total DUSD supply (Probably the FED never will use it) haha
    function burnMoney(uint256 _amount) external onlyFED {
        uint256 oldSupply = totalSupply();
        _burn(msg.sender, _amount);
        emit supplyDecreased(msg.sender, oldSupply, totalSupply());
    }

    // Function to stake DUSD and earn interest (Treasury bonds)
    function stakeDUSD(uint256 _amount) external {
        require(_amount > 0, "0 is not valid");
        require(balanceOf(msg.sender) >= _amount, "Not enough funds");

        if(stakedTreasuryBonds[msg.sender] > 0) claimInterest(); // Claim before staking more
        stakedTimeStamp[msg.sender] = block.timestamp;
        stakedTreasuryBonds[msg.sender] += _amount;
        transferFrom(msg.sender, address(this), _amount);
        emit DUSDStaked(msg.sender, _amount, block.timestamp);
    }

    // Function to unstaked DUSD and claim rewards (Treasury bonds)
    function unstakeDUSD(uint256 _amount) external {
        require(_amount > 0, "0 is not valid");
        require(stakedTreasuryBonds[msg.sender] >= _amount, "Not enough funds staked");

        claimInterest();
        stakedTreasuryBonds[msg.sender] -= _amount;
        transferFrom(address(this), msg.sender, _amount);
        emit DUSDUnstaked(msg.sender, _amount, block.timestamp);
    }

    // Function to claim the rewards (Treasury bonds)
    function claimInterest() public {
        require(stakedTreasuryBonds[msg.sender] > 0, "Not enough funds staked");
        uint256 DUSDstaked = stakedTreasuryBonds[msg.sender];
        uint256 secondsStaked = block.timestamp - stakedTimeStamp[msg.sender];
        uint256 reward = DUSDstaked * secondsStaked * interestRates / (1000* 3.154e7); //1000 * 3.154e7 => Seconds in a year.

        stakedTimeStamp[msg.sender] = block.timestamp; // Reset the staked time stamp to now.
        _mint(msg.sender, reward);
        emit interestClaimed(msg.sender, reward, totalSupply());
    }

    // Function to update the interests rate points for staking (Treasury bonds)
    function updateInterestRates(uint256 _interest) external onlyFED{
        uint256 oldInterestRates = interestRates;
        interestRates = _interest;
        emit InterestRatesUpdated(oldInterestRates, _interest);
    }
}
