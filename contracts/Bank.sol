//SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;

/**
 * @title Bank thats stores users balances.
 * @author Raiyan Mukhtar
 * @notice You cna use this contract to deposit eth into the bank
 * make withdrawals
 * @dev used Withdrawal pattern to prevent re-entrancy attacks
 */

contract Bank {
    /// @notice stores the addresses of users in the bank
    address[] users;

    /// @notice stores the users address with their balances
    mapping(address => uint) public balances;

    /// @notice stores the owner of the contract
    address private immutable owner;

    /// @notice Emitted when a deposit is made
    event AfterDeposit(
        address indexed account,
        uint indexed amount,
        bool success
    );

    /// @notice Emitted when a withdrawal is made.
    event AFterWithdrawal(
        address indexed account,
        uint indexed amount,
        bool success
    );

    /// @dev modifier for only th owner.
    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthrorized Caller");
        _;
    }

    /// @notice modifier to check if the value is enough
    modifier checkValue(uint val) {
        require(val != 0, "Not Enough ETH");
        _;
    }

    /// @dev using address(0) which check if addrress is not
    /// a zero address (0x00)
    modifier checkAddress(address _addr) {
        require(_addr != address(0));
        _;
    }

    constructor() {
        /// @dev initialize the owner of the contract
        owner = msg.sender;
    }

    /// @dev this called when a user send Eth into the contract directly
    //// without calling functions
    receive() external payable {
        /// @dev call the deposit function when triggered
        deposit();
    }

    /**
     * @dev this is called when:
     *  1. the receive function is not available
     *  2. when a function called thats not available in
     * the contract.
     */
    fallback() external payable {
        /// @dev call the deposit function when triggered
        deposit();
    }

    /**
     * @dev deposit funds into the contract but before that
     * check if the value is enough (calling the modifier).
     * @return balance -> returns the balance of the user.
     */
    function deposit()
        public
        payable
        checkAddress(msg.sender)
        checkValue(msg.value)
        returns (uint balance)
    {
        /// @dev adds the user address to the
        users.push(msg.sender);

        /// @dev adds the balance of user in the map
        balances[msg.sender] += msg.value;

        ///@notice get current balance
        balance = balances[msg.sender];

        emit AfterDeposit(msg.sender, msg.value, true);

        /// @notice return balance
        return balance;
    }

    /**
     * @notice withdraw funds from the contract by the user
     * @dev used a Withdrawal pattern to prevent re-entrancy attacks
     * @return _balance -> returns the balance of the user.
     */
    function withdrawEth(uint _amount)
        external
        checkAddress(msg.sender)
        checkValue(_amount)
        returns (uint _balance)
    {
        /**
         * @dev before sending eth deduct from account
         */
        balances[msg.sender] -= _amount;

        /**
         * @notice send the eth to the caller
         * @dev casted the msg.sender a payable since any address
         * receiveing eth has to be payable.
         *  */
        payable(msg.sender).transfer(_amount);

        /// @notice get current balance of user
        _balance = balances[msg.sender];

        emit AFterWithdrawal(msg.sender, _amount, true);

        /// @notice return balance
        return _balance;
    }

    /**
     * @notice get the current balance of the caller
     * @return balance
     */
    function getAccountBalance() external view returns (uint balance) {
        /// @notice get the current balance of user
        balance = balances[msg.sender];
        /// @notice return balance
        return balance;
    }
}
