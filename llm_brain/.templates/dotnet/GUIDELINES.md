# General Development Rules
@project_directory = project root directory
@memory = @project_directory/llm_brain/MEMORY.md
@brief = @project_directory/llm_brain/BRIEF.md
@review = @project_directory/llm_brain/REVIEW.md
@TODO = @project_directory/llm_brain/TODO.md
 

You should do task-based development. For every task, you should write the tests, implement the code, and run the tests to make sure everything works. Use `dotnet test` to run the tests or use `dotnet test --filter "FullyQualifiedName~TypeConversionTests"` to run a specific test.

When the tests pass:
* Update the todo list to reflect the task being completed
* Update the memory file to reflect the current state of the project
* Fix any warnings or errors in the code
* Commit the changes to the repository with a descriptive commit message
* Update the development guidelines to reflect anything that you've learned while working on the project
* Stop and we will open a new chat for the next task

## Retain Memory

There will be a memory file for every project.

The memory file will contain the state of the project, and any notes or relevant details you'd need to remember between chats.

Keep it up to date based on the project's current state. 

Do not annotate task completion in the memory file. It will be tracked in the to-do list.

## Update development guidelines

If necessary, update the development guidelines to reflect anything you've learned while working on the project.