# AIgent Orange
> AI project template for AI Agentic Development

## Credit
Full credit for starting this project and developing this workflow goes to John at Generaite Labs: https://generaitelabs.com/one-agentic-coding-workflow-to-rule-them-all/

I decided to try out this workflow and thought it would be nice to have a github project template to start with and used his prompts and file structure to start with. I've distilled his article in this README but for a full explanation, please visit his blog. Kudos John! He has great articles that I encourage everyone to check out at https://generaitelabs.com/blog/.

## Usage

1. Write up a project brief - a high level overview of the application.
    - Vision of project
    - Features
        - description of feature
        - when (what phase) it will be implemented in the project
    - Overall architecture
    - Entities
    - Business Rules
    - Success Metrics
    - Any other technical details
2. Technical Implementation Plan
    - Detail models
    - Libraries used
    - Interfaces
    - Services
3. Dependency Analysis
    - Ask model to find dependency problems
4. TODO list
    - Ask AI to generate initial todo list from implementation plan
    - Markdown file with checkmarks
5. Start Coding Loop
    - Reference all included files that the LLM needs to keep project context:
        1. @project_folder
        2. @memory
        3. @TODO
        4. @GUIDELINES
        5. @REVIEW
    - Prompt AI: 
    ```
        Continue working on the project in @project_folder. Follow the development guidelines in @development guidelines, and remember everything in @memory.
    ```


## Tips

* Use a good model
* Make a good plan
* Keep chats small

