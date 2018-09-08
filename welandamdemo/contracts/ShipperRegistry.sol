pragma solidity ^0.4.24;

contract ShipperRegistry {

    // TODO hard code shippers

    event ShipperRegistered(address indexed shipperEthAddress, bytes shipperIpfsHash);
    event ShipperStateChanged(address indexed shipperEthAddress, bool enabled);

    address public owner;

    struct Shipper {
        // this should be a party registered on governance registry
        address registeredBy;

        // blah
        address shipperEthAddress;

        // Link to IPFS file to get shipper info
        bytes shipperIpfsHash;

        // enabled or not
        bool enabled;
    }

    // mapping from shipper address to shipper struct for easy verifiability
    mapping(address => Shipper) public shippers;

    constructor() public {
        // Can owner be a governance contract?
        // if possible make the data store separate from all the validation logic, so that it can be migrated
        owner = msg.sender;
    }

    // TODO should only be callable by a party on gov registry(colony)
    function addShipper(address _shipperEthAddress, bytes _shipperIpfsHash) public {
        require(_shipperIpfsHash.length != 0);
        require(_shipperEthAddress != 0x0);
        require(shippers[_shipperEthAddress].shipperEthAddress == 0x0);
        shippers[_shipperEthAddress] = Shipper(
            msg.sender,
            _shipperEthAddress,
            _shipperIpfsHash,
        // for now approved by default, later we can have a better approval process
            true);
        // TODO should also register shipper on colony

        emit ShipperRegistered(_shipperEthAddress, _shipperIpfsHash);
    }

    // TODO should only be callable by a party on gov registry(colony)
    function disableShipper(address _shipperEthAddress) public {
        require(_shipperEthAddress != 0x0);
        require(shippers[_shipperEthAddress].shipperEthAddress != 0x0);
        shippers[_shipperEthAddress].enabled = false;

        emit ShipperStateChanged(_shipperEthAddress, false);
    }

    // TODO should only be callable by a party on gov registry(colony)
    function enableShipper(address _shipperEthAddress) public {
        require(_shipperEthAddress != 0x0);
        require(shippers[_shipperEthAddress].shipperEthAddress != 0x0);
        shippers[_shipperEthAddress].enabled = true;

        emit ShipperStateChanged(_shipperEthAddress, true);
    }

    // verify and get shipper IPFS address - this is for relayers
    function getShipper(address _shipperEthAddress) public view returns (bytes) {
        require(_shipperEthAddress != 0x0);
        require(shippers[_shipperEthAddress].shipperEthAddress != 0x0);
        require(shippers[_shipperEthAddress].enabled);

        return shippers[_shipperEthAddress].shipperIpfsHash;
    }

}
