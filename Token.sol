pragma solidity ^0.4.18;

import "./ERC20.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

contract Token is Ownable {
    using SafeMath for uint;

    string public name = "Invox";
    string public symbol = "INVOX";
    uint8 public decimals = 18;
    uint256 public totalSupply = 0;

    address private owner;

    address internal constant FOUNDERS = 0x16368c58BDb7444C8b97cC91172315D99fB8dc81;
    address internal constant OPERATIONAL_FUND = 0xc97E0F6AcCB18e3B3703c85c205509d02700aCAa;

    uint256 private constant MAY_15_2018 = 1526342400;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    function Token () public {
        balances[msg.sender] = 0;
    }

    function balanceOf(address who) public constant returns (uint256) {
        return balances[who];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0));
        require(balances[msg.sender] >= value);

        require(now >= MAY_15_2018 + 14 days);

        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);

        Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(from != address(0));
        require(to != address(0));
        require(balances[from] >= value && allowed[from][msg.sender] >= value && balances[to] + value >= balances[to]);

        balances[from] = balances[from].sub(value);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
        balances[to] = balances[to].add(value);

        Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0));
        require(allowed[msg.sender][spender] == 0 || amount == 0);

        allowed[msg.sender][spender] = amount;
        Approval(msg.sender, spender, amount);
        return true;
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
}