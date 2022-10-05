pragma solidity ^0.8.0;
// SPDX-License-Identifier: GPL-3.0
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

    struct Order{

        uint orderID;
        Burger burgerType;
    }

    constructor(address payable _owner){
        owner = _owner;
        menu["Economy"]=  Burger({cost : 1000 , maxSupply : 100, currentSupply : 0 , name : "Economy" ,currentStage : Stages.readyToOrder });
        menu["Business"] = Burger({cost : 2000 , maxSupply : 70, currentSupply : 0 , name : "Business" ,currentStage : Stages.readyToOrder });
        menu["Deluxe"] =  Burger({cost : 4000 , maxSupply : 50, currentSupply : 0 , name : "Deluxe" ,currentStage : Stages.readyToOrder });

    }

    event boughtBurger(address indexed from  , Burger burger);

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

    function isCooking(Stages currStage) public pure returns (bool){

        return currStage == Stages.cooking;
    }

    function  isReadyToOrder(Stages currStage) public pure returns (bool){

        return currStage == Stages.readyToOrder;
    }
    
    function isReadyToTake(Stages currStage) public pure returns (bool) {

        return currStage == Stages.readyToTake;
    }

    function buyBurger(string memory burgerName ) payable public  canBeOrdered(menu[burgerName] ){

        (bool success , ) = owner.call{ value: msg.value}("");
        require(success , "Transactoin Didnt Go through");

    }

  
 

}