pragma solidity ^0.4.24;

contract MerchantRegistry {

    // TODO hard code merchants

    event MerchantRegistered(address indexed merchantEthAddress, bytes merchantIpfsHash);
    event MerchantStateChanged(address indexed merchantEthAddress, bool enabled);

    address public owner;

    struct Merchant {
        // this should be a party registered on governance registry
        address registeredBy;

        // blah
        address merchantEthAddress;

        // Link to IPFS file to get merchant info
        bytes merchantIpfsHash;

        // enabled or not
        bool enabled;
    }

    // mapping from merchant address to merchant struct for easy verifiability
    mapping(address => Merchant) public merchants;

    constructor() public {
        // Can owner be a governance contract?
        // if possible make the data store separate from all the validation logic, so that it can be migrated
        owner = msg.sender;
    }

    // TODO should only be callable by a party on gov registry(colony)
    function addMerchant(address _merchantEthAddress, bytes _merchantIpfsHash) public {
        require(_merchantIpfsHash.length != 0);
        require(_merchantEthAddress != 0x0);
        require(merchants[_merchantEthAddress].merchantEthAddress == 0x0);
        merchants[_merchantEthAddress] = Merchant(
            msg.sender,
            _merchantEthAddress,
            _merchantIpfsHash,
        // for now approved by default, later we can have a better approval process
            true);
        // TODO should also register merchant on colony

        emit MerchantRegistered(_merchantEthAddress, _merchantIpfsHash);
    }

    // TODO should only be callable by a party on gov registry(colony)
    function disableMerchant(address _merchantEthAddress) public {
        require(_merchantEthAddress != 0x0);
        require(merchants[_merchantEthAddress].merchantEthAddress != 0x0);
        merchants[_merchantEthAddress].enabled = false;

        emit MerchantStateChanged(_merchantEthAddress, false);
    }

    // TODO should only be callable by a party on gov registry(colony)
    function enableMerchant(address _merchantEthAddress) public {
        require(_merchantEthAddress != 0x0);
        require(merchants[_merchantEthAddress].merchantEthAddress != 0x0);
        merchants[_merchantEthAddress].enabled = true;

        emit MerchantStateChanged(_merchantEthAddress, true);
    }

    // verify and get merchant IPFS address - this is for relayers
    function getMerchant(address _merchantEthAddress) public view returns (bytes) {
        require(_merchantEthAddress != 0x0);
        require(merchants[_merchantEthAddress].merchantEthAddress != 0x0);
        require(merchants[_merchantEthAddress].enabled);

        return merchants[_merchantEthAddress].merchantIpfsHash;
    }

}
