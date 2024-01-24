pragma solidity 0.8.10;

contract Autolisting 
{
    string public name = "DEX223 autolisting contract";

    uint256 public num_pairs;
    uint256 public last_update = block.timestamp;
    mapping (uint256 => address) public pairs;
    
    function add_pairs(address[] memory _pairs) public /* onlyOwner */
    {
        uint256 _position = num_pairs;
        num_pairs += _pairs.length;

        for (uint i = 0; i < _pairs.length; i++)
        {
            pairs[_position] = _pairs[i];
            _position++;
        }

        //pairs[num_pairs] = _pairs[0];
        last_update = block.timestamp;
    }

    function get_pairs(uint256 _start, uint256 _end) public view returns (address[] memory)
    {
        address[] memory _pairs = new address[](_end - _start);
        uint256 _array_index = 0;
        for (uint256 i = _start; i < _end; i++)
        {
            _pairs[_array_index] = pairs[i];
            _array_index++;
        }
        return _pairs;
    }
}
