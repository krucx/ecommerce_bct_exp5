// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Ecommerce{

    struct Product{
        uint256 productid;
        string title;
        string desc;
        address payable seller;
        uint256 amount;
        uint8 state;
        address buyer;
    }

    Product[] public products;

    function registerProduct(string memory _title, string memory _desc, uint _amount) public{
        products.push(Product({productid:products.length,title:_title,desc:_desc,seller:payable(msg.sender),amount:_amount*(10**18),state:0,buyer:address(0)}));
    }

    function buyProduct(uint256 _productid) public payable{
        require(products[_productid].state==0, "Cant sell already sold product");
        require(msg.sender != products[_productid].seller, "Seller cant buy the product");
        require(msg.value == products[_productid].amount, "Cant buy product with higher or lower amount");
        products[_productid].state = 1;
        products[_productid].buyer = msg.sender;
    }

    function deliveryConfirmation(uint256 _productid) public payable{
        require(products[_productid].state==1, "Cant deliver unsold product");
        require(msg.sender == products[_productid].buyer, "Delivery can be confirmed only by the buyer");
        products[_productid].state=2;
        products[_productid].seller.transfer(products[_productid].amount);
    }

    function findUnsoldProducts() public view returns(Product[] memory) {
        uint256 resultCount;
        for (uint i = 0; i < products.length; i++) {
            if (products[i].state == 0) {
                resultCount++;
            }
        }
        Product[] memory result = new Product[](resultCount);
        uint256 j;
        for (uint i = 0; i < products.length; i++) {
            if (products[i].state == 0) {
                result[j] = products[i];
                j++;
            }
        }
        return result;
    }
}