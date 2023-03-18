pragma solidity ^0.8.10;

interface IERC20{
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract FYJ_ERC20 is IERC20 {
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name;
    string public symbol;
    uint8 public decimals;

    address owner;

    constructor() {
        owner = msg.sender;
        name = "fcoin";
        symbol = "FC";
        decimals = 18;
        _incoin(msg.sender,100*10**18);
    }

    function _incoin(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERROR: incoin to the zero address");
        totalSupply = amount;
        balanceOf[account] = amount;
        emit Transfer(address(0), account, amount);
    }

    function transfer(address recipient, uint256 amount) external returns (bool){
        require(balanceOf[msg.sender]>=amount, "ERROR: not enough balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool){
        require(balanceOf[sender]>=amount, "ERROR: not enough balance");
        require(allowance[sender][msg.sender]>=amount, "ERROR: not enough allowance");

        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    //增發
    function mint(address account, uint256 amount) external virtual {
        require(owner==msg.sender,"sender error");
        totalSupply += amount;
        balanceOf[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    //銷毀
    function burn(uint256 amount) external virtual {
        require(owner==msg.sender,"sender error");
        require(balanceOf[owner] >= amount, "burn error");
        balanceOf[owner] = balanceOf[owner] - amount;
        totalSupply -= amount;
        emit Transfer(owner, address(0), amount);
    }

}