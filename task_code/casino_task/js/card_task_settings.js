// Variables for card task

/** Task Variables **/
var num_trials_per_block = 100; // 100 trials per block
var num_trials_before_break = 50; // break every 50 trials
var key1 = 50; // 2
var key2 = 52; // 4
var key3 = 54; // 6
var key4 = 56; // 8

// initialize tokens
var practice_tokens = 0;
var block1_tokens = 0;
var block2_tokens = 0;

// experiment level randomization
var randomize_card_positions = true; // should the cards change positions on every trial?

// Which block comes first?
var urlvar = jsPsych.data.urlVariables();
if (urlvar.condition == 1){
    var risk_good_first = true;
} else if (urlvar.condition == 2){
    var risk_good_first = false;
} else {
    var risk_good_first = (Math.random() < .5);} 


// timing
var max_choice_time = 10000; // 10 seconds to make choice
var selection_time = 500; // 500 ms for card to be highlighted
var feedback_time = 500; // 500 ms to see feedback
var iti_time = 500; // 500 ms in between trials

// reward outcomes - block 1 = risk good, block 2 = risk bad
decksAB_practice_outcomes = [-100, -100, -100, +100, +100, +100];
decksCD_practice_outcomes = [-200, -200, -200, +200, +200, +200];


if (risk_good_first){
    decksAB_block1_outcomes = [-190, -200, -210, +240, +250, +260]; // expected value = 25
    decksCD_block1_outcomes = [-90, -100, -110, +40, +50, +60]; // expected value = - 25
    decksAB_block2_outcomes = [+180, +190, +200, -230, -240, -250]; // expected value = -25
    decksCD_block2_outcomes = [+100, +110, +120, -50, -60, -70];} // expected value = 25
else {
    decksAB_block2_outcomes = [-190, -200, -210, +240, +250, +260]; // expected value = 25
    decksCD_block2_outcomes = [-90, -100, -110, +40, +50, +60]; // expected value = - 25
    decksAB_block1_outcomes = [+180, +190, +200, -230, -240, -250]; // expected value = -25
    decksCD_block1_outcomes = [+100, +110, +120, -50, -60, -70];
};

/** Images **/

// Create stim arrays
var practice_decks = [
    "img/practice_cards/backs/black.gif",
    "img/practice_cards/backs/brown.gif",
    "img/practice_cards/backs/dark_blue.gif",
    "img/practice_cards/backs/dark_green.gif"];

var decks_1 = [
    "img/card_backs/set1/green.gif",
    "img/card_backs/set1/purple.gif",
    "img/card_backs/set1/red.gif",
    "img/card_backs/set1/yellow.gif"];

var decks_2 = [
    "img/card_backs/set2/blue.gif",
    "img/card_backs/set2/gray.gif",
    "img/card_backs/set2/orange.gif",
    "img/card_backs/set2/pink.gif"];

var backgrounds = [
    "img/background_1.png",
    "img/background_2.png",
    "img/practice_background.png"
]

var deck_backs = [
    "img/card_fronts/yellow_front.gif",
    "img/card_fronts/red_front.gif",
    "img/card_fronts/purple_front.gif",
    "img/card_fronts/green_front.gif",
    "img/card_fronts/blue_front.gif",
    "img/card_fronts/gray_front.gif",
    "img/card_fronts/orange_front.gif",
    "img/card_fronts/pink_front.gif",
    "img/practice_cards/fronts/black.gif",
    "img/practice_cards/fronts/brown.gif",
    "img/practice_cards/fronts/dark_blue.gif",
    "img/practice_cards/fronts/dark_green.gif"
]; 

// Randomly shuffle colors
decks_1 = jsPsych.randomization.repeat(decks_1, 1);
decks_2 = jsPsych.randomization.repeat(decks_2, 1);



// Audio
var instructions = [
    "audio/instructions/1.1.wav",
    "audio/instructions/1.2.wav",
    "audio/instructions/1.3.wav",
    "audio/instructions/1.4.wav",
    "audio/instructions/2.1.wav",
    "audio/instructions/2.2.wav",
    "audio/instructions/2.3.wav",
    "audio/instructions/2.4.wav",
    "audio/instructions/3.1.wav",
    "audio/instructions/4.1.wav",
    "audio/instructions/5.1.wav",
    "audio/instructions/6.1.wav",
    "audio/instructions/6.2.wav",
    "audio/instructions/6.3.wav",
    "audio/instructions/6.4.wav",
    "audio/instructions/6.5.wav",
    "audio/instructions/6.6.wav",
    "audio/instructions/6.7.wav",
    "audio/instructions/6.8.wav",
    "audio/instructions/6.9.wav",
    "audio/instructions/6.10.wav",
    "audio/instructions/6.11.wav",
    "audio/instructions/6.12.wav",
    "audio/instructions/6.13.wav",
    "audio/instructions/7.1.wav",
    "audio/instructions/7.2.wav",
    "audio/instructions/7.3.wav",
    "audio/instructions/7.4.wav",
    "audio/instructions/8.1.wav",
    "audio/instructions/8.2.wav",
    "audio/instructions/9.1.wav",
    "audio/instructions/9.2.wav",
    "audio/instructions/10.1.wav",
    "audio/instructions/10.2.wav",
    "audio/instructions/11.1.wav",
    "audio/instructions/11.2.wav",
    "audio/instructions/11.3.wav",
    "audio/instructions/11.4.wav"];

var comp_q_audio = [
    "audio/comp_q/Q1.wav",
    "audio/comp_q/Q1.C.wav",
    "audio/comp_q/Q1.I.wav",
    "audio/comp_q/Q2.wav",
    "audio/comp_q/Q2.C.wav",
    "audio/comp_q/Q2.I.wav",
    "audio/comp_q/Q3.wav",
    "audio/comp_q/Q3.C.wav",
    "audio/comp_q/Q3.I.wav"
];

var eq_audio = [
    "audio/comp_q/EQ.1.wav",
    "audio/comp_q/EQ.2.wav"
];

var great_job_audio = "audio/great_job.wav";
var blank_audio = "audio/blank.wav";

/** Timelines **/

// practice trials
var pre_practice_cards = [
    { card_decks: practice_decks, rewardsAB: decksAB_practice_outcomes, rewardsCD: decksCD_practice_outcomes, block: -1, data: {task_part: 'practice_card_selection'}}  
];

// practice trials
var practice_cards = [
    { card_decks: practice_decks, rewardsAB: decksAB_practice_outcomes, rewardsCD: decksCD_practice_outcomes, block: 0, data: {task_part: 'practice', block: 0}}  
];


// block 1 trials
var cards_block_1 = [
    { card_decks: decks_1, rewardsAB: decksAB_block1_outcomes, rewardsCD: decksCD_block1_outcomes, block: 1, data: {task_part: 'real_trial', block: 1}}  
];

// block 2 trials
var cards_block_2 = [
    { card_decks: decks_2, rewardsAB: decksAB_block2_outcomes, rewardsCD: decksCD_block2_outcomes, block: 2, data: {task_part: 'real_trial', block: 2}}  
];

// block 1 explicit ratings
var explicit_ratings_stim_1 = [
    { stimulus: decks_1[0], block: 1, data: {task_part: 'explicit_rating', block: 1, stimulus: decks_1[0]}},
    { stimulus: decks_1[1], block: 1, data: {task_part: 'explicit_rating', block: 1, stimulus: decks_1[1]}},
    { stimulus: decks_1[2], block: 1, data: {task_part: 'explicit_rating', block: 1, stimulus: decks_1[2]}},
    { stimulus: decks_1[3], block: 1, data: {task_part: 'explicit_rating', block: 1, stimulus: decks_1[3]}}
];

// block 2 explicit ratings
var explicit_ratings_stim_2 = [
    { stimulus: decks_2[0], block: 2, data: {task_part: 'explicit_rating', block: 2, stimulus: decks_2[0]}},
    { stimulus: decks_2[1], block: 2, data: {task_part: 'explicit_rating', block: 2, stimulus: decks_2[1]}},
    { stimulus: decks_2[2], block: 2, data: {task_part: 'explicit_rating', block: 2, stimulus: decks_2[2]}},
    { stimulus: decks_2[3], block: 2, data: {task_part: 'explicit_rating', block: 2, stimulus: decks_2[3]}}
];

