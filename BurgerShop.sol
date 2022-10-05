// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract BurgerShop{
   
    address payable public   owner;
    mapping(string => Burger) menu;
    enum Stages {
            readyToOrder,
            cooking,
            readyToTake,
            orderTaken

        }
    struct Burger{
        uint cost;
        uint maxSupply;
        uint currentSupply;
        string name;
        Stages currentStage;
        

    }


    constructor() payable{
        owner = payable(msg.sender);
        menu["Economy"]=  Burger({cost : 0.0000001 ether , maxSupply : 100, currentSupply : 0 , name : "Economy" ,currentStage : Stages.readyToOrder });
        menu["Business"] = Burger({cost : 0.000002 ether , maxSupply : 70, currentSupply : 0 , name : "Business" ,currentStage : Stages.readyToOrder });
        menu["Deluxe"] =  Burger({cost : 0.000005 ether , maxSupply : 50, currentSupply : 0 , name : "Deluxe" ,currentStage : Stages.readyToOrder });

    }

    event boughtBurger(address indexed by  , Burger burger);

    modifier isOwner() {

        require(msg.sender == owner , "The Sender should be owner!!");
        _;
    }

    modifier canBeOrdered(Burger memory burger ){

        require(msg.value >= burger.cost , "The Cost the burger is more");
        require(isReadyToTake(burger.currentStage) ,"The Burger is not ready to take!!");
        require(burger.maxSupply > burger.currentSupply,  "The max limit of burger s reached");

        _;
    }

    function chageStage(Stages newStage ,string memory burgerName) public view isOwner{
        getBurger(burgerName).currentStage = newStage;
    }

    function isCooking(Stages currStage) public pure returns (bool){

        return currStage == Stages.cooking;
    }

    function  isReadyToOrder(Stages currStage) public pure returns (bool){

        return currStage == Stages.readyToOrder;
    }
    
    function isReadyToTake(Stages currStage) public pure returns (bool) {

        return currStage == Stages.readyToTake;
    }

    function buyBurger(string calldata burgerName  ) payable public  canBeOrdered(menu[burgerName] ){

        (bool success , ) = owner.call{ value: msg.value}("");
        require(success , "Transaction didn't go through");
        emit boughtBurger(msg.sender , getBurger(burgerName));

    }

    function getBurgerPrice(string memory burgerName) public view returns(uint){
        return menu[burgerName].cost;
    }
    function getBurger(string memory burgerName) public view returns (Burger memory){
        return menu[burgerName];
    }


  
 

}