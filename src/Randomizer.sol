contract Randomizer {
    address owner;
    uint256 firstNumberHash;
    uint256 secondNumber;
    uint256 resultNumber;
    
    // При условии, что первый пользователь это owner
    function Randomizer(uint256 hash) public payable {
        firstNumberHash = hash;
        owner = msg.sender;
    }
    
    function set(uint256 number) public {
        require(secondNumber == 0 , "Number already setted");
        require(msg.sender != owner , "Owner cannot send numbers");
        require(number != 0 , "You cannot send 0");
        
        // Думаю, что тут уже можно не хэшировать число
        secondNumber = number;
    }
    
    function confirm(uint256 firstNumber) public returns (uint256)  {
        require(secondNumber != 0 , "Someone should send second number");
        require(msg.sender == owner , "You are not allowed to send firstNumber");
        
        // Cравниваем хэш этого числа с изначальным хэшем
        // Допустим по условию он хэшировал через keccak256
        uint256 hash = uint256(keccak256(firstNumber));
        require(firstNumberHash == hash , "Wrong number");
        
        resultNumber = uint256(keccak256(firstNumber,secondNumber));
        return resultNumber;
    }
    
    function result() public returns (uint256) {
        if (msg.sender == owner) {
            require(secondNumber != 0 , "Someone must send second number");
            require(resultNumber != 0 , "You must send your number");
        } else {
            require(secondNumber != 0 , "You must set second number");
            require(resultNumber != 0 , "Owner must send his number");
        }
        return resultNumber;
    }
}
