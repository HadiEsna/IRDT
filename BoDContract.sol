pragma solidity ^0.4.0;

contract BoDContract {
    address[] BoDAddresses;

    modifier isAuthority(address authority) {
        bool isBoD = false;
        for (uint i = 0; i < BoDAddresses.length; i++) {
            if (authority == BoDAddresses[i]) {
                isBoD = true;
            }
        }
        require(isBoD);
        _;
    }

    modifier notInBoD(address addr){
        bool flag = true;
        for (uint i = 0; i < BoDAddresses.length; i++) {
            if (addr == BoDAddresses[i]) {
                flag = false;
            }
        }
        require(flag);
        _;
    }

    struct TransformObject {
        uint8 transformCounter;
        address from;
        address to;
    }

    TransformObject transformObject;

    uint8 transformCounter;

    constructor (address[] BoDAddressHa) {
        BoDAddresses = BoDAddressHa;
    }

    function transformAuthority(address from, address to) notInBoD(to) isAuthority(msg.sender) isAuthority(from) public returns (bool) {

        if (transformObject.transformCounter == 0 || transformObject.from != from || transformObject.to != to) {
            transformObject.from = from;
            transformObject.to = to;
            transformObject.transformCounter = 1;
            return true;
        }
        transformObject.transformCounter = transformObject.transformCounter.add(1);

        if(transformObject.transformCounter==BoDAddresses.length-1){
            transform(from, to);
            transformObject.transformCounter = 0;
        }

        return true;
    }

    function transform(address from, address to) public returns (bool){
        for (uint i = 0; i < BoDAddresses.length; i++) {
            if (from == BoDAddresses[i]) {
                BoDAddresses[i] = to;
                return true;
            }
        }
        return true;
    }
}