contract Randomizer {
    uint256 firstNumber;
    uint256 secondNumber;
    address owner;
    
    // При условии, что первый пользователь это owner
    function Randomizer(uint256 number) public payable {
        firstNumber = number;
        owner = msg.sender;
    }
    
    function set(uint256 number) public returns (uint256) {
        require(secondNumber == 0 , "Number already setted");
        require(msg.sender != owner , "Owner cannot send numbers");
        require(number != 0 , "You cannot send 0");
        secondNumber = uint256(keccak256(msg.sender,number));
        return uint256(keccak256(firstNumber,secondNumber));
    }
    function number() public returns (uint256) {
        if (msg.sender == owner) {
            require(secondNumber != 0 , "Someone else should send second number");
        } else {
            require(secondNumber != 0 , "You must set second number");
        }
        return uint256(keccak256(firstNumber,secondNumber));
    }
}