// SPDX-License-Identifier: GPL-3.0


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
/** 
 * @title Central Vault
 * @dev Users can deposit Central Tokens in 5 different slabs 
 */

pragma solidity 0.8.17;


contract CentralVault is Ownable {
 
     //Events to deposit and withdraw tokens
     event DepositTokens(address user, uint256 amount);
     event WithdrawTokens(address user, uint256 amount, uint256 vaultTokens);

     IERC20 public centralTokenAddress;

      /**
     * @notice Construct a new Vault with token address and define capacity slab
     * @param _centralTokenAddress The Central token address
     */
    constructor(IERC20 _centralTokenAddress) {
        centralTokenAddress = _centralTokenAddress;
        initSlabCapacities();

    }
    
    /// @notice For denoting the different slabs
    enum slabStatus{
        SLAB0,
        SLAB1,
        SLAB2,
        SLAB3,
        SLAB4
    }

 
    /// @notice For monitoring the capacity in each slabs
    struct Slab{
        slabStatus capacitySlab;
        uint256 slabAmount;
    }

    struct userDetails{
        address user;
        slabStatus slabType;
    }

       /// @notice For mapping user address to amount of Central tokens deposited in this vault
    mapping (address => mapping (IERC20 => uint256)) userTokenBalance;


    /// @notice For determining which slab user belongs to
    mapping (address => userDetails) userSlab;


    Slab[5] public slabs;

    function initSlabCapacities() internal{
        slabs[0].slabAmount = 100;
        slabs[1].slabAmount = 200;
        slabs[2].slabAmount = 300;
        slabs[3].slabAmount = 400;
        slabs[4].slabAmount = 500;
    }

    function setSlabCapacities(uint256[5] memory _capacities) external onlyOwner{
        slabs[0].slabAmount = _capacities[0];
        slabs[1].slabAmount = _capacities[1];
        slabs[2].slabAmount = _capacities[2];
        slabs[3].slabAmount = _capacities[3];
        slabs[4].slabAmount = _capacities[4];
    }


     /**
     * @notice Called by the user for depositing Central tokens which also checks the capacity slab levels
     * @param  amount The amount of central tokens to deposit
     */
    function DepositCentralTokens( uint256 amount) public {
        require(IERC20(centralTokenAddress).balanceOf(msg.sender) >= amount, "Your token balance must be greater than the amount you are trying to deposit");
        require(IERC20(centralTokenAddress).approve(address(this), amount));
        IERC20(centralTokenAddress).transferFrom(msg.sender, address(this), amount);

        userTokenBalance[msg.sender][centralTokenAddress] += amount;
        if((userTokenBalance[msg.sender][centralTokenAddress])<=500){
            userSlab[msg.sender].slabType = slabStatus.SLAB4;
        }
        if((userTokenBalance[msg.sender][centralTokenAddress])<=900){
            userSlab[msg.sender].slabType = slabStatus.SLAB3;
        }
        if((userTokenBalance[msg.sender][centralTokenAddress])<=1200){
            userSlab[msg.sender].slabType = slabStatus.SLAB2;
        }
        if((userTokenBalance[msg.sender][centralTokenAddress])<=1400){
            userSlab[msg.sender].slabType = slabStatus.SLAB1;
        }
        if((userTokenBalance[msg.sender][centralTokenAddress])<=1500){
            userSlab[msg.sender].slabType = slabStatus.SLAB0;
        }
        emit DepositTokens(msg.sender, amount);
    }

    function checkVaultCapacity() public view returns (uint256){
        return address(this).balance;

    }

    function checkUserSlab() public view returns (userDetails memory){
        return userSlab[msg.sender];

    }

}