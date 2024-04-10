// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PaymentGateway is Ownable {
    uint8 constant USDC_DECIMALS = 6;
    IERC20 public usdcToken;

    constructor(address _token) Ownable(msg.sender) {
        usdcToken = IERC20(_token);
    }

    /// @dev Event to log token receive
    event TokensReceived(address from, uint256 amount);

    /// @dev  Function to receive USDC payments - require approve first
    function pay(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than zero");
        /// @dev  uint256 allowance = usdcToken.allowance(msg.sender, address(this));

        /// @dev require(allowance >= _amount, "Insufficiat allowance.");

        /// @dev  Transfer USDC tokens from sender to this contract
        bool success = usdcToken.transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        require(success, "USDC transfer failed");

        /// @dev Emit event
        emit TokensReceived(msg.sender, _amount);
    }

    /// @dev Function to withdraw USDC tokens from the contract (only owner)
    function withdraw(uint256 _amount) external onlyOwner {
        _amount = _amount * (10 ** USDC_DECIMALS);

        require(_amount > 0, "Amount must be greater than zero");

        /// @dev Ensure contract has sufficient balance
        require(
            usdcToken.balanceOf(address(this)) >= _amount,
            "Insufficient USDC balance"
        );

        /// @dev Transfer USDC tokens to owner
        bool success = usdcToken.transfer(owner(), _amount);

        require(success, "USDC transfer failed");
    }

    /// @dev Function to allow owner to withdraw ETH from the contract
    function withdrawETH(uint256 amount) external onlyOwner {
        require(
            address(this).balance >= amount,
            "Insufficient ETH balance in contract"
        );
        payable(owner()).transfer(amount);
    }

    /// @dev Function to get the contract's USDC balance
    function getContractBalance() external view returns (uint256) {
        return usdcToken.balanceOf(address(this));
    }

    function renounceOwnership() public view override onlyOwner {
        revert("Ownership can not renounced");
    }
}
