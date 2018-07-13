contract Randomizer {
    uint256 generatorSeed;
    address public owner;
    mapping (address => uint256) private users;
    
    function Randomizer(string password) public payable {
        // создаём сид для генерации последующих чисел
        generatorSeed = uint256(keccak256(password));
        generatorSeed = random(generatorSeed);
    }
    
    function join(string yourPassword) public {
        require(users[msg.sender] == 0, "You already joined");
        
        // Берём хэш пароля и рандомизируем его с generatorSeed
        uint256 value = uint256(keccak256(yourPassword));
        value = random(value);
        value *= generatorSeed;
        value = random(value);
        users[msg.sender] = value;
    }
    
    function numberFor(address user) public returns (uint256) {
        require(user != msg.sender, "You cannot send your address in address field");
        require(users[msg.sender] != 0, "Your account not found. Please join first");
        require(users[user] != 0, "User not found");
        
        // Берём числа пользователей. 
        // Сортируем из через "<" чтобы они были в одинаковом порядке при запросе с обоих сендеров
        uint256 first;
        uint256 second;
        if (msg.sender < user) {
            first = users[msg.sender];
            second = users[user];
        } else {
            first = users[user];
            second = users[msg.sender];
        }
        
        // Вычисляем число
        uint256 result = first;
        result *= second;
        result *= generatorSeed;
        return random(result);
    }
    
    function random(uint256 y) private returns (uint256) {
        uint256 a = 0x1bea4149536195e7dc498fa7fa68fb435565a867daee79f06029620fa7583313;
        uint256 b = 0xdc3e381976204eced11873b4e91ed39b9fe62abcee8635047629d392f03d703b;
        uint256 c = 0x74e5e1b2c6cc6050919374654928b11e17f2919c61067b91a365dfdaa911f4cb;
        uint256 d = 0x5973bdf32ccce2b9eecc272c0ca94e563020977b4a6246bbd5d80730041b0df8;
        uint256 e = 0x46a59bb3f902356d5e524d0c486e96f232ba4f4fe79c621ea1ef99749d3dac93;
        // Рандомизируем число
        y = (y >> 87) ^ y;
        y = (y * (y * y * e * a) + b);
        y = (y * (y * y * c + d) * b);
        
        // Умножаем его на сид
        y *= generatorSeed;
        return y;
    }
}
