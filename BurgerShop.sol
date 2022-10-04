pragma solidity ^0.8.0;
// SPDX-License-Identifier: GPL-3.0
contract BurgerShop{
    Burger[] menu;
    address payable public   owner;
    enum Stages {
            readyToOrder,
            cooking,
            readyToTake

        }
    struct Burger{
        uint cost;
        uint totalSupply;
        string name;
        uint currentSupply;
        Stages currentStage;
        

    }

    constructor(address payable _owner){
        owner = _owner;
    }

    event boughtBurger(address indexed from  , Burger burger);

    modifier isOwner() {

        require(msg.sender == owner , "The Sender should be owner!!");
        _;
    }

    modifier canBeBought(Burger storage burger){

        require(msg.value >= burger.cost , "The Cost the burger is more");
        require(burger.currentStage == Stages.readyToOrder , "The burger is not ready to be ordered!!");
        require(burger.totalSupply > burger.currentSupply);

        _;
    }

    