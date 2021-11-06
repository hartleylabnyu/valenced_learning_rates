// instructions
var instructions_1 = [
    {stimulus: "Welcome to the casino!" , 
    audio: instructions[0],
    choices: 'g', continue_delay: 1500, data: {task_part: 'instructions'}},

    {stimulus: "Today you will be playing a game to earn tokens. </br> At the end of the experiment, you will be paid a bonus based on how many tokens you win. " , 
    audio: instructions[1],
    choices: 'e', continue_delay: 8000, data: {task_part: 'instructions'}},

    {stimulus: "On every turn, you will be shown four different decks of cards. </br> You need to select a card from one of the four decks.  " , 
    audio: instructions[2],
    choices: 'k', continue_delay: 6000, data: {task_part: 'instructions'}},

    {stimulus: "On the next screen, you will see what the decks will look like. " , 
    audio: instructions[3],
    choices: 'b', continue_delay: 3500, data: {task_part: 'instructions'}}

];


var instructions_2 = [
    {stimulus: "You should pick a card from a deck using the '2', '4', '6', and '8' keys at the top of the keyboard." , 
    audio: instructions[4],
    choices: 'u', continue_delay: 6000, data: {task_part: 'instructions'}},

    {stimulus: "Once you select a card, it will turn over and you will see how many tokens you earned." , 
    audio: instructions[5],
    choices: 's', continue_delay: 4000, data: {task_part: 'instructions'}},

    {stimulus: "Let's try practicing that! </br> First, try to put your fingers over the '2', '4', '6', and '8' keys. </br>  You can use whatever fingers are most comfortable for you. Try to find a comfortable position now. " , 
    audio: instructions[6],
    choices: '2', continue_delay: 13000, data: {task_part: 'instructions'}},

    {stimulus: "Okay ready? </br> On the next screen, press '2' to select the left deck. " , 
    audio: instructions[7],
    choices: '2', continue_delay: 5000, data: {task_part: 'instructions'}}

];

var instructions_3 = [
    {stimulus: "Great! Now on the next screen, try pressing '6' to select the third deck." , 
    audio: instructions[8],
    choices: '6', continue_delay: 5000, data: {task_part: 'instructions'}}

];

var instructions_4 = [
    {stimulus: "Now on the next screen, try pressing '4' to select the second deck." , 
    audio: instructions[9],
    choices: '4', continue_delay: 4000, data: {task_part: 'instructions'}}

];

var instructions_5 = [
    {stimulus: "Finally, try pressing '8' to select the deck all the way on the right." , 
    audio: instructions[10],
    choices: '8', continue_delay: 4000, data: {task_part: 'instructions'}}
];

var instructions_6 = [
    {stimulus: "Great! It seems like you are getting the hang of this." , 
    audio: instructions[11],
    choices: 'p', continue_delay: 2000, data: {task_part: 'instructions'}},

    {stimulus: "You may have noticed that some cards will cause you to <b> win </b> tokens while other cards will cause you to <b> lose </b>  tokens." , 
    audio: instructions[12],
    choices: 'f', continue_delay: 6000, data: {task_part: 'instructions'}},

    {stimulus: "Each deck has a mix of cards that will cause you to win and lose tokens. </br> However, the cards in each colored deck are different." , 
    audio: instructions[13],
    choices: 'i', continue_delay: 7000, data: {task_part: 'instructions'}},

    {stimulus: "Some colored decks are luckier than others. </br> If you choose the lucky decks, you will earn more tokens than if you choose the unlucky decks." , 
    audio: instructions[14],
    choices: 'e', continue_delay: 7000, data: {task_part: 'instructions'}},

    {stimulus: "You should try to figure out which decks are lucky. </br> Then, try to choose the lucky decks so you can win the most tokens." , 
    audio: instructions[15],
    choices: 'w', continue_delay: 6000, data: {task_part: 'instructions'}},

    {stimulus: "To make it trickier, the casino dealer will switch the locations of the decks on every turn. </br> The color of the deck determines how lucky it is. The location does not matter.",
    audio: instructions[16],
    choices: 'x', continue_delay: 10000, data: {task_part: 'instructions'}},

    {stimulus: "The mix of cards in each colored deck will stay the same throughout the game. </br> That means that a deck that is lucky early on will stay lucky.", 
    audio: instructions[17],
    choices: 'o', continue_delay: 8000, data: {task_part: 'instructions'}},

    {stimulus: "Remember though, all the decks have a <b> mix </b> of both <b> good </b> and <b> bad </b> cards so it may take a couple of turns to figure out if a deck is lucky.", 
    audio: instructions[18],
    choices: 'e', continue_delay: 7000, data: {task_part: 'instructions'}},

    {stimulus: "At the end of the game, you will be paid bonus money based on how many tokens you win. </br> If you win more tokens, you will earn more money!" , 
    audio: instructions[19],
    choices: 'h', continue_delay: 7000, data: {task_part: 'instructions'}},

    {stimulus: "You will never <b> lose </b> money. </br> If you end up with fewer than 0 tokens, you will earn $0 of bonus money, but you will still be paid for playing the game." , 
    audio: instructions[20],
    choices: 's', continue_delay: 9000, data: {task_part: 'instructions'}},

    {stimulus: "You will have 10 seconds to make each choice." , 
    audio: instructions[21],
    choices: 'r', continue_delay: 3000, data: {task_part: 'instructions'}},

    {stimulus: "Before you play the game for real, you will play with practice decks. </br> The tokens you earn during practice won't count toward your total.",
    audio: instructions[22],
    choices: 'v', continue_delay: 7000, data: {task_part: 'instructions'}},

    {stimulus: "Ready? Remember, use the '2', '4', '6', and '8' keys to select the decks. </br> Put your fingers on those keys now and then press '2' to begin.",
    audio: instructions[23],
    choices: '2', continue_delay: 11000, data: {task_part: 'instructions'}}
];


var instructions_7 = [
    {stimulus: "Nice job! You are almost ready to play the real game." , 
    audio: instructions[24],
    choices: 'v', continue_delay: 3000, data: {task_part: 'instructions'}},

    {stimulus: "You will play two rounds of the real game. In each round, you will pick 100 cards in total." , 
    audio: instructions[25],
    choices: 'i', continue_delay: 5000, data: {task_part: 'instructions'}},

    {stimulus: "We are now going to ask you some questions about how the game works." , 
    audio: instructions[26],
    choices: 'b', continue_delay: 3000, data: {task_part: 'instructions'}},

    {stimulus: "Answer carefully. You will not be able to begin the game until you answer them correctly." , 
    audio: instructions[27],
    choices: 'c', continue_delay: 5000, data: {task_part: 'instructions'}},
];

var instructions_8 = [
    {stimulus: "Great job! Now it's time to start the real game.",
    audio: instructions[28],
    choices: 'r', continue_delay: 3000, data: {task_part: 'instructions'}},

    {stimulus: "Before we start, we're going to head into a new room of the casino.",
    audio: instructions[29],
    choices: 'v', continue_delay: 4000, data: {task_part: 'instructions'}},
];


var instructions_9 = [
    {stimulus: "Here we are! The real game will use different cards, but the rules will be the same.",
    audio: instructions[30],
    choices: 'g', continue_delay: 5000, data: {task_part: 'instructions'}},

    {stimulus: "Ready? Put your fingers over the '2', '4', 6', and '8' keys so you are ready to play the game. </br> Then press 2 to start.",
    audio: instructions[31],
    choices: '2', continue_delay: 9000, data: {task_part: 'instructions'}},
];



var instructions_10 = [
    {stimulus: "Awesome work. You finished the first round of the game. Please take a break." , 
    audio: instructions[32],
    choices: 'd', continue_delay: 5000, data: {task_part: 'instructions'}},

    {stimulus: "You are now going to play the second round of the game in a NEW room of the casino. </br> Let's head there now. " , 
    audio: instructions[33],
    choices: 'w', continue_delay: 5000, data: {task_part: 'instructions'}}];


var instructions_11 = [

    {stimulus: "Here we are! All of the rules are the same, but the card decks will be different. " , 
    audio: instructions[34],
    choices: 's', continue_delay: 4000, data: {task_part: 'instructions'}},

    {stimulus: "You will need to try to learn which of these new decks are lucky and unlucky." , 
    audio: instructions[35],
    choices: 'y', continue_delay: 4000, data: {task_part: 'instructions'}},

    {stimulus: "Remember, do your best to earn as many tokens as possible because you will win real money at the end of the game." , 
    audio: instructions[36],
    choices: 'i', continue_delay: 6000, data: {task_part: 'instructions'}},

    {stimulus: "Good luck! </br> Put your fingers over the '2', '4', 6', and '8' keys so you are ready to play the game. </br> Then press 2 to start." , 
    audio: instructions[37],
    choices: '2', continue_delay: 8000, data: {task_part: 'instructions'}}
];


// Comprehension questions
var comp_question1 = [
    {stimulus: "True or False: All the decks have some cards that cause you to win tokens and some cards that cause you to lose tokens.",
    audio: comp_q_audio[0],
    correct_key: 84, 
    right_response: "True is correct! All the decks have a mix of winning and losing cards.", 
    right_audio: comp_q_audio[1],
    wrong_response: "False is incorrect. All the decks have a mix of winning and losing cards.", 
    wrong_audio: comp_q_audio[2],
    choices: 'm',
    continue_delay: 6500, 
    data: {task_part: "comp_q"}
}]

var comp_question2 = [
    {stimulus: "True or False: You will have as much time as you want to make your response.",
    audio: comp_q_audio[3],
    correct_key: 70, 
    right_response: "False is correct! You will only have 10 seconds to make each choice.", 
    right_audio: comp_q_audio[4],
    wrong_response: "True is incorrect. You will only have 10 seconds to make each choice.", 
    wrong_audio: comp_q_audio[5],
    choices: 'k',
    continue_delay: 4000, 
    data: {task_part: "comp_q"}
}]

var comp_question3 = [
    {stimulus: "True or False: The location of the deck determines how lucky it is.",
    audio: comp_q_audio[6],
    correct_key: 70, 
    right_response: "False is correct! The <i>color</i>  of the deck determines how lucky or unlucky it is.", 
    right_audio: comp_q_audio[7],
    wrong_response: "True is incorrect. The <i>color</i> of the deck determines how lucky or unlucky it is.", 
    wrong_audio: comp_q_audio[8],
    choices: 'd',
    continue_delay: 4500, 
    data: {task_part: "comp_q"}
}]

