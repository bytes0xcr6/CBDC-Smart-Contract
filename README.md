# CBDC Smart Contract - Digital USD (DUSD)
CBDC is a smart contract written in Solidity that enables the creation and management of a Central Bank Digital Currency. The contract is built on top of the ERC20 standard and uses OpenZeppelin's ERC20 implementation.


## Functionality
The following are the main functions of the CBDC smart contract:

### Blacklist
`manageBlackList(address _criminal, uint8 _decision) external onlyFED`: Adds or removes an address to the blacklist. Blacklisted addresses cannot receive or send DUSD tokens.
### FED
`updateFED(address _newFed) external onlyFED`: Updates the FED address.

### DUSD
`printMoney(uint256 _amount) external onlyFED`: Mints new DUSD tokens to the FED address.

`burnMoney(uint256 _amount) external onlyFED`: Destroys DUSD tokens held by the FED address.

### Treasury Bonds
`stakeDUSD(uint256 _amount) external`: Allows users to stake DUSD tokens and earn interest in the form of Treasury Bonds.

`unstakeDUSD(uint256 _amount) external`: Allows users to withdraw their staked DUSD tokens and claim their earned Treasury Bonds.

`claimInterest() public`: Claims earned Treasury Bonds.

`updateInterestRates(uint256 _interest) external onlyFED`: Updates the interest rates for Treasury Bonds.

### Deployment
The contract has been deployed on the Ethereum network with Solidity compiler version 0.8.19 and uses OpenZeppelin's ERC20 implementation. The contract has been licensed under the MIT license.

## Contributing
Contributions to this project are always welcome and appreciated. If you would like to contribute, please follow these steps:

- Fork the repository
- Create a new branch for your feature or bug fix
- Make changes to the code and test thoroughly
- Create a pull request back to the main branch
- Please ensure that your code adheres to the Solidity style guide and is well-documented. Additionally, any new features or significant changes should include appropriate tests.

Thank you for your interest in contributing to this project!

### Author
The CBDC smart contract has been created by Cristian Richarte Gil.
