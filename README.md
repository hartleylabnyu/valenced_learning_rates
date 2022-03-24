# Flexibility in valenced reinforcement learning computations across development
Tasks, data, and analysis code for: Nussenbaum, K., Velez, J.A., Washington, B.T., Hamling, H.E., & Hartley, C.A. (in press). Flexibility in valenced reinforcement learning computations across development. *Child Development.*

We collected data from 154 participants on two tasks: a novel reinforcement learning task
and the Matrix Reasoning Item Bank (MaRs-IB) as described in Chierchia, Fuhrmann et al. (2019). 

## Tasks
Versions of both tasks, coded in [jsPsych](https://www.jspsych.org/), can be found in the "tasks" folder.
_Please note: the tasks were designed to be hosted on [Pavlovia](https://pavlovia.org/). As such, they will not run locally unless the Pavlovia-specific code is commented out._ 

### 1. Reinforcement learning task (Casino Game)
Participants make a series of choices among four decks of cards to try to gain as many tokens as possible. Participants make 100 choices between four card decks in two blocks. The distribution of cards was different within each deck. In each block, two decks were ‘risky’ such that they had high gains but also high losses. Two decks were ‘safe’ and had more moderate gains and losses. Critically, in one block of the task, the average value of the risky decks was positive (25 tokens) and the average value of the safe decks was negative (-25 tokens), whereas in the other block of the task, the average value of the risky decks was negative (-25 tokens) and the average value of the safe decks was positive (25 tokens). 

### 2. Matrix Reasoning Item Bank (MaRs-IB)
This abstract reasoning task was developed by and originally described in [Chierchia, Furhmann et al. (2019)](https://royalsocietypublishing.org/doi/10.1098/rsos.190232). All stimuli used in the task are from the [OSF repository](https://osf.io/g96f4/) set up by the original study authors.

Participants complete a series of reasoning puzzles within an 8-minute time limit.
The jsPsych version of the task uses one of the color-blind friendly stimulus sets as well as the "minimal" distractors described in the original manuscript. It was coded by the Hartley Lab for use online with children, adolescents, and adults.

## Data and analysis code
All raw data and analysis code can be found in the "analysis_code_and_data" folder. All analyses and results reported in the manuscript can be reproduced by running the R scripts (for all data summary statistics and regression analyses) and matlab code (for the computational modeling of reinforcement learning task data). 

The html files and figures folder contain all model results and generated figures. 