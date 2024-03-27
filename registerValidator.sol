// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

    contract distributed_validator {
        address public owner;
        address[] public clusters;
        mapping(address=>bool) public isCluster;
        mapping(address=>bool) public registeredValidator;
        mapping(address=>string[]) public validatorShares;
            
  
    event ValidatorRegistered(address indexed validator, address indexed cluster);
         

         constructor() {
            owner = msg.sender;
         }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }


    function selectClusters(address[] memory _clusters) external onlyOwner {
        require(_clusters.length >0, "At least one cluster must be selected");
        for (uint i = 0; i < _clusters.length; i++) {
            clusters.push(_clusters[i]);
            isCluster[_clusters[i]] = true;
        }
    }

    function retrieveValidator(address _account, address _cluster) external view returns(bytes memory) {
        require(isCluster[_cluster], "Invalid cluster address");
        return abi.encodePacked("Events data for account", _account, "in cluster", _cluster);
    }


    function splitValidatorKey(string[] memory _shares) external {
        require(_shares.length >0, "At least one share must be provided");
        require(_shares.length == clusters.length, "number of shares must match numbder of clusters");
        for (uint i = 0; i< _shares.length; i++) {
            validatorShares[msg.sender].push(_shares[i]);
        }

    }


     function registerValidator(address _cluster) external {
        require(isCluster[_cluster], "Invalid cluster address");
        require(validatorShares[msg.sender].length == clusters.length, "Validator shares not fully distributed");
        require(!registeredValidator[msg.sender], "Validator already registered");

        registeredValidator[msg.sender] = true;
        emit ValidatorRegistered(msg.sender, _cluster);
    }

    }
