pragma solidity ^0.4.24;

contract RelayerRegistry {

    // TODO hard code relayers

    event RelayerRegistered(address indexed relayerEthAddress, bytes relayerIpfsHash);
    event RelayerStateChanged(address indexed relayerEthAddress, bool enabled);

    address public owner;

    struct Relayer {
        // this should be a party registered on governance registry
        address registeredBy;

        // blah
        address relayerEthAddress;

        // Link to IPFS file to get relayer info
        bytes relayerIpfsHash;

        // enabled or not
        bool enabled;
    }

    // mapping from relayer address to relayer struct for easy verifiability
    mapping(address => Relayer) public relayer;

    constructor() public {
        // Can owner be a governance contract?
        // if possible make the data store separate from all the validation logic, so that it can be migrated
        owner = msg.sender;
    }

    // TODO should only be callable by a party on gov registry(colony)
    function addRelayer(address _relayerEthAddress, bytes _relayerIpfsHash) public {
        require(_relayerIpfsHash.length != 0);
        require(_relayerEthAddress != 0x0);
        require(relayer[_relayerEthAddress].relayerEthAddress == 0x0);
        relayer[_relayerEthAddress] = Relayer(
            msg.sender,
            _relayerEthAddress,
            _relayerIpfsHash,
        // for now approved by default, later we can have a better approval process
            true);
        // TODO should also register relayer on colony

        emit RelayerRegistered(_relayerEthAddress, _relayerIpfsHash);
    }

    // TODO should only be callable by a party on gov registry(colony)
    function disableRelayer(address _relayerEthAddress) public {
        require(_relayerEthAddress != 0x0);
        require(relayer[_relayerEthAddress].relayerEthAddress != 0x0);
        relayer[_relayerEthAddress].enabled = false;

        emit RelayerStateChanged(_relayerEthAddress, false);
    }

    // TODO should only be callable by a party on gov registry(colony)
    function enableRelayer(address _relayerEthAddress) public {
        require(_relayerEthAddress != 0x0);
        require(relayer[_relayerEthAddress].relayerEthAddress != 0x0);
        relayer[_relayerEthAddress].enabled = true;

        emit RelayerStateChanged(_relayerEthAddress, true);
    }

    // verify and get relayer IPFS address - this is for relayers
    function getRelayer(address _relayerEthAddress) public view returns (bytes) {
        require(_relayerEthAddress != 0x0);
        require(relayer[_relayerEthAddress].relayerEthAddress != 0x0);
        require(relayer[_relayerEthAddress].enabled);

        return relayer[_relayerEthAddress].relayerIpfsHash;
    }

}
