pragma solidity ^0.4.24;

contract Welandam {

    // TODO minimize data structs

    address public owner;

    // TODO allow changing this using governance
    uint numRelayersPerOrder = 2;

    constructor() public {
        // Can owner be a governance contract?
        // if possible make the data store separate from all the validation logic, so that it can be migrated
        owner = msg.sender;
    }

    // hashes and signatures to do ecrecover
    struct Party {

        bytes32 hash;

        bytes signature;
    }

    // TODO this struct only needs the settlement amount and a reference to an encrypted order object on ipfs
    struct Order {

        bytes16 id;

        // TODO how to make this private while also allowing the contract and authorized parties to verify the item
        // one way would be to store the encrypted order on IPFS and store the hash here?
        bytes itemIpfsHash;

        // amount payable in ether
        uint64 amount;

        // TODO decide on exactly how we can handle any number of relayers while also encouraging
        // all the network participants to relay everyone elses orders
        // TODO This is a key problem that differentiates welandam from 0x since in 0x, in order to share liquidity for exchange orders there is a natural incentive for relayers to share maker orders
        Party[] relayers;

        Party shipper;

        Party merchant;

        Party customer;

    }

    struct OrderConfirmation {
        // UUID
        bytes16 id;

        Party shipper;

        Party customer;
    }

    // Only stores orders until confirmed
    // TODO what about returns? do we need a grace period?
    mapping(bytes16 => Order) public pendingOrders;

    bytes16[] public executedOrders;

    // called by any protocol participant
    // TODO param Order memory _order
    function recordOrder() public {
        // TODO verify sender is in governance registry
        // TODO ecrecover addresses
        // TODO verify parties using registries
        // TODO validate order object
        // TODO hold amounts from customer account
        // TODO pay the relayer
        //pendingOrders[_order.id] = _order;

    }

    // TODO param OrderConfirmation memory _orderConfirmation
    function confirmOrder() public {
        // TODO verify order is in pending
        // TODO verify customer signature
        // TODO verify shipper signature
        // TODO transfer amounts to parties
        //executedOrders.push(_orderConfirmation.id);
        //delete pendingOrders[_orderConfirmation.id];

    }
}
