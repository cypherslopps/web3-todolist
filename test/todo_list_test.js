const TodoListContract = artifacts.require("TodoList");

contract("TodoList", accounts => {
  let todoList;
  const owner = accounts[0];

  it("contract has been deployed", async function () {
    todoList = await TodoListContract.deployed();
    assert(todoList, "contract was not deployed");
  });

  describe("adding new todo category", () => {
    const id = 0;
    const title = "Coding";
    const color = "red";

    it("increases myTodoCategoriesCount", async () => {
      const currentTodoCategoriesCount = await todoList.myTodoCategoriesCount();

      await todoList.addTodoCategory(
        id,
        title,
        color,
        { from: owner }
      );

      const newTodoCategoriesCount = await todoList.myTodoCategoriesCount();
      const diff = newTodoCategoriesCount - currentTodoCategoriesCount;

      assert.equal(
        1,
        diff,
        "myTodoCategoriesCount should increase by 1"
      );
    });

    it("increases todo category in myTodoCategories", async () => {
      await todoList.addTodoCategory(
        id,
        title,
        color,
        { from: owner }
      );

      const { ids, titles, colors, dates } = await todoList.myTodoCategories({ from: owner });

      assert.equal(
        id,
        ids[0],
        "ids should match"
      );
      assert(titles[0], "title should be present");
      assert(colors[0], "color should be present");
      assert(dates[0], "date should be present");
    });

    it("emits the TodoCategoryAdded event", async () => {
      const tx = await todoList.addTodoCategory(
        id,
        title,
        color,
        { from: owner }
      );

      const expectedEvent = "TodoCategoryAdded";
      const actualEvent = tx.logs[0].event;

      assert.equal(
        actualEvent,
        expectedEvent,
        "events should match"
      );
    });
  });

  describe("adding new todo", () => {
    const id = 0;
    const content = "Solidity: Building a Todo Contract";
    const status = false;
    const categoryId = 0;

    it("increases totalTodoCount", async () => {
      const currentTodoCount = await todoList.totalTodoCount();

      await todoList.addTodo(
        id,
        content,
        status,
        categoryId,
        { from: owner }
      );

      const newTodoCount = await todoList.totalTodoCount();
      const diff = newTodoCount - currentTodoCount;

      assert.equal(
        diff,
        1,
        "difference should match the total todo count"
      );
    });
  });
});
