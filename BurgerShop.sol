pragma solidity ^0.8.0;
// SPDX-License-Identifier: GPL-3.0
contract BurgerShop{
    Burger[] menu;
    struct Burger{
        uint cost;
        uint totalSupply;
        string name;
        uint currentSupply;
        

    }


}