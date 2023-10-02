// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract TodoList {
  
  using SafeMath for uint256;

  uint256 public totalTodoCount;

  struct Todo {
    uint256 id;
    string content;
    bool status;
    uint128 categoryId;
    uint256 date;
  }

  struct Category {
    uint256 id;
    string title;
    string color;
    uint256 date;
  }

  // event TodoAdded(address indexed owner, uint256 id);
  event TodoCategoryAdded(address indexed owner, string title);

  modifier onlyOwner(address owner) {
    require(
      msg.sender == owner,
      "Ownable: caller is not the owner"
    );
    _;
  }

  mapping(address => mapping(string => Todo[])) private _categoryOfTodo;
  mapping(address => Category[]) private _category;

  function myTodoCategoriesCount() public view returns(uint256) {
    return _category[msg.sender].length;
  }

  function myTodoCategories() public view returns(
    uint256[] memory ids,
    string[] memory titles,
    string[] memory colors,
    uint256[] memory dates
  ) {
    uint256 count = myTodoCategoriesCount();
    ids = new uint256[](count);
    titles = new string[](count);
    colors = new string[](count);
    dates = new uint256[](count);

    for(uint256 i = 0; i < count; i++) {
      Category storage category = _category[msg.sender][i];
      ids[i] = category.id;
      titles[i] = category.title;
      colors[i] = category.color;
      dates[i] = category.date;
    }

    return (
      ids,
      titles,
      colors,
      dates
    );
  }

  function addTodo(
    uint256 id,
    string memory content,
    bool status,
    uint128 categoryId
  ) public onlyOwner(msg.sender) {
    require(_category[msg.sender][categoryId].id == categoryId);
    Todo memory todo = Todo({
      id: id,
      content: content,
      status: status,
      categoryId: categoryId,
      date: block.timestamp
    });

    string storage category = _category[msg.sender][categoryId].title;
    _categoryOfTodo[msg.sender][category].push(todo);
    
    // Increments total count
    totalTodoCount++;

    // emit TodoAdded(msg.sender, id);
  }

  function addTodoCategory(
    uint256 id,
    string memory title,
    string memory color
  ) public onlyOwner(msg.sender) {
    Category memory category = Category({
      id: id,
      title: title,
      color: color,
      date: block.timestamp
    });

    _category[msg.sender].push(category);
    emit TodoCategoryAdded(msg.sender, title);
  }
}
