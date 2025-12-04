// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// ---------------------------------------------------------------------------
/// MyToken (MTK) - Simple ERC-20 Token
/// ---------------------------------------------------------------------------
/// Features Implemented ✓
/// - Token Metadata (name, symbol, decimals)
/// - Total Supply assigned to contract deployer
/// - balanceOf(address)
/// - transfer(to, amount)
/// - approve(spender, amount)
/// - transferFrom(from, to, amount)
/// - allowance(owner, spender)
/// - Transfer + Approval events
/// - Validation checks (balance, allowance, zero address)
/// ---------------------------------------------------------------------------

contract MyToken {

    // ──────────────────────────
    //  TOKEN METADATA
    // ──────────────────────────
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8  public decimals = 18;

    uint256 public totalSupply;

    // ──────────────────────────
    //  BALANCES + ALLOWANCES
    // ──────────────────────────
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // ──────────────────────────
    //  EVENTS
    // ──────────────────────────
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // ──────────────────────────
    //  CONSTRUCTOR
    // ──────────────────────────
    constructor(uint256 _totalSupply) {
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;       // Mint full supply to deployer
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // ──────────────────────────
    //  TRANSFER (Normal)
    // ──────────────────────────
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Invalid recipient");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // ──────────────────────────
    //  APPROVE ALLOWANCE
    // ──────────────────────────
    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0), "Invalid spender");

        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    // ──────────────────────────
    //  TRANSFER WITH ALLOWANCE (transferFrom)
    // ──────────────────────────
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "Invalid recipient");
        require(balanceOf[_from] >= _value, "From address doesn't have enough");
        require(allowance[_from][msg.sender] >= _value, "Allowance too low");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }
}
