pragma solidity 0.8.10;

contract Autolisting 
{
    string public name = "DEX223 autolisting contract";

    uint256 num_batches = 0;
    uint8   batch_size  = 10;
    mapping (uint256 => address[]) public pairs;

    // Adds pair contract addresses in batches.
    // `pairs[0]` contains 10 pair addresses
    // `pairs[1]` contains another 10 addresses
    // and so on ...
    function add_pairs(address[] calldata _pairs) public
    {
        // Just some logic of adding addresses in batches.
        uint256 _position = pairs[num_batches].length;

        for (uint i = _pairs.length; i > 0; i--)
        {
            pairs[num_batches].push( _pairs[i] );
            _position++;
            if (_position == batch_size)
            {
                num_batches++;
                _position = 0;
            }
        }
    }

    // The UI is supposed to call this function to obtain `batch_size` number of pair addresses
    // starting from `batch_id` = 0 until `batch_id` becomes equal to `num_batches`
    // upon reaching `num_batches` the UI considers that all pairs stored in the contract are red.
    //
    // The UI expects to get `batch_size` number of addresses per call. Therefore we are
    // reducing the number of API calls by `batch_size` times.
    function UI_query_pairs(uint256 batch_id) public view returns (address[] memory)
    {
        return pairs[batch_id];
    }
}
