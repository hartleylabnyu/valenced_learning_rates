/**
 * jspsych-card-selection-trial
 * KN
 *
 * plugin for displaying a centered image w/ two images as choices, getting a response, and providing feedback
 *
 *
 **/

jsPsych.plugins["card-selection-trial"] = (function () {

  var plugin = {};

  jsPsych.pluginAPI.registerPreload('card-selection-trial', 'image');

  plugin.info = {
    name: 'card-selection-trial',
    description: '',
    parameters: {
      block: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Block',
        default: 1,
        description: "Block of task"
      },
      card_decks: {
        type: jsPsych.plugins.parameterType.IMG,
        array: true,
        pretty_name: 'Card decks',
        description: 'Array of card decks to display',
        default: null
      },
      casino_background: {
        type: jsPsych.plugins.parameterType.IMG,
        pretty_name: 'Casino background',
        description: 'Background image',
        default: 'img/background1.png'
      },
      valid_choices: {
        type: jsPsych.plugins.parameterType.KEYCODE,
        array: true,
        pretty_name: 'Valid choices',
        default: [key1, key2, key3, key4],
        description: 'The keys the subject is allowed to press to respond to the stimulus.'
      },
      highlighted_choice: {
        type: jsPsych.plugins.parameterType.INT,
        array: true,
        pretty_name: 'Highlighted choice',
        default: null,
        description: 'The choice that should pulse.'
      },
      rewards_AB: {
        type: jsPsych.plugins.parameterType.INT,
        array: true,
        pretty_name: 'Deck AB outcomes',
        description: 'Number of points earned for AB decks if chosen.',
        default: [0, 0, 0, 1, 1, 1]
      },
      rewards_CD: {
        type: jsPsych.plugins.parameterType.INT,
        array: true,
        pretty_name: 'Deck CD outcomes',
        description: 'Number of points earned for CD decks if chosen.',
        default: [0, 0, 0, 1, 1, 1]
      },
      choice_duration: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Choice duration',
        default: max_choice_time,
        description: 'How long the participant has to make their choice.'
      },
      feedback_duration: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Feedback duration',
        default: 2000,
        description: 'How long to display feedback for.'
      },
      disp_warning: {
        type: jsPsych.plugins.parameterType.BOOL,
        pretty_name: 'Display timeout warning',
        default: true,
        description: "Should participants be warned if they don't respond in time?"
      },
      display_keys: {
        type: jsPsych.plugins.parameterType.BOOL,
        pretty_name: 'Display keys',
        default: true,
        description: "Should participants see what keys to press?"
      },

      }
    }
  

  plugin.trial = function (display_element, trial) {

    // Randomly determine card positions
    var positions = [0, 1, 2, 3];
    var shuffled_positions = jsPsych.randomization.repeat(positions, 1);

     // determine rewards for decks A - D
     var rewards = [0, 0, 0, 0];
     rewards[0] = jsPsych.randomization.sampleWithReplacement(trial.rewards_AB, 1);
     rewards[1] = jsPsych.randomization.sampleWithReplacement(trial.rewards_AB, 1);
     rewards[2] = jsPsych.randomization.sampleWithReplacement(trial.rewards_CD, 1);
     rewards[3] = jsPsych.randomization.sampleWithReplacement(trial.rewards_CD, 1);

     // determine orderd rewards
     var ordered_rewards = [rewards[shuffled_positions[0]], rewards[shuffled_positions[1]], rewards[shuffled_positions[2]], rewards[shuffled_positions[3]]];

     // determine keys
     var keys = [2, 4, 6, 8]


    // ---------------------------------- //
    // Section 1: Define HTML             //
    // ---------------------------------- //

    // Define HTML
    var new_html = '';

    // Start casino wrapper.
    new_html += `<div class="casino-wrap" block=${trial.block}>`;

    // Start casino container
    new_html += '<div class="casino-grid">';

    // Iteratively draw card decks
    for (let i=0; i<4; i++){

      // determine position
      var position = shuffled_positions[i];

      // Get name of card deck image
      var deck_img = trial.card_decks[position];


      // Determine deck back
      if (deck_img == 'img/card_backs/set1/green.gif') {
          deck_back_img = 'img/card_fronts/green_front.gif';
      } else if (deck_img == 'img/card_backs/set1/red.gif'){
          deck_back_img = 'img/card_fronts/red_front.gif';
      } else if (deck_img == 'img/card_backs/set1/purple.gif'){
          deck_back_img = 'img/card_fronts/purple_front.gif'; 
      } else if (deck_img == 'img/card_backs/set1/yellow.gif'){
          deck_back_img = 'img/card_fronts/yellow_front.gif';
        } else if (deck_img == 'img/card_backs/set2/blue.gif'){
          deck_back_img = 'img/card_fronts/blue_front.gif';
      } else if (deck_img == 'img/card_backs/set2/gray.gif'){
          deck_back_img = 'img/card_fronts/gray_front.gif'; 
      } else if (deck_img == 'img/card_backs/set2/pink.gif'){
          deck_back_img = 'img/card_fronts/pink_front.gif';
        } else if (deck_img == 'img/card_backs/set2/orange.gif'){
          deck_back_img = 'img/card_fronts/orange_front.gif';
      }  else if (deck_img == 'img/practice_cards/backs/black.gif'){
          deck_back_img = 'img/practice_cards/fronts/black.gif';
        }  else if (deck_img == 'img/practice_cards/backs/brown.gif'){
          deck_back_img = 'img/practice_cards/fronts/brown.gif';
        }  else if (deck_img == 'img/practice_cards/backs/dark_blue.gif'){
          deck_back_img = 'img/practice_cards/fronts/dark_blue.gif';
        }  else if (deck_img == 'img/practice_cards/backs/dark_green.gif'){
          deck_back_img = 'img/practice_cards/fronts/dark_green.gif';
      }


      // Start deck container 
      new_html += `<div class="card-deck" id="card-deck-${i}" >`;

      // Draw card image
      new_html += ` <img src="${deck_img}" id="card-deck-img-${i}" class="card-deck-img" stage="1" position="${i}">`;

      // Draw card back image
      new_html += ` <img src="${deck_back_img}" id="card-deck-back-img-${i}" class="card-deck-back-img" stage="1" position="${i}">`;

      // Draw card deck text
      new_html += `<div class="card-deck-text" stage="1" id="card-deck-text-${i}"> ${rewards[position]} </div>`

      // Draw card deck key text
      if (trial.display_keys){
        if (trial.highlighted_choice == i){
      new_html += `<div class="card-deck-key-text" stage="1" type="pulse" id="card-deck-key-text-${i}"> ${keys[i]} </div>`
      } else {
        new_html += `<div class="card-deck-key-text" stage="1" type="normal" id="card-deck-key-text-${i}"> ${keys[i]} </div>`
      }}

      // Finish deck container
      new_html += '</div>'; 
    }

    // Close casino container.
    new_html += '</div>';

    // Close casino wrapper.
    new_html += '</div>'

    // render
    display_element.innerHTML = new_html;


    // ---------------------------------- //
    // Section 2: jsPsych Functions       //
    // ---------------------------------- //

    // Store response
    var response = {
      key: null,
      card_choice: null,
      choice_position: null,
      rt: null,
      points: null
    };

    // function to handle missed responses
    var missed_response = function() {

      // Kill all setTimeout handlers.
      jsPsych.pluginAPI.clearAllTimeouts();
      jsPsych.pluginAPI.cancelAllKeyboardResponses();

      // Display warning message.
      if (trial.disp_warning) {
      const msg = `<div class="casino-wrap" block=${trial.block}> <div id="jspsych-casino-keyboard-response-stimulus" class="instructions-text"> You did not respond in time. <br/> Please try to pick a deck before time runs out. </div></div>`;
      display_element.innerHTML = msg;
      }

      jsPsych.pluginAPI.setTimeout(function() {
        end_trial();
      }, 3000);

    }

    // function to handle responses by the subject
    var after_response = function(info) {

      display_element.querySelector('#card-deck-key-text-0').setAttribute('stage', 'selected')
      display_element.querySelector('#card-deck-key-text-1').setAttribute('stage', 'selected')
      display_element.querySelector('#card-deck-key-text-2').setAttribute('stage', 'selected')
      display_element.querySelector('#card-deck-key-text-3').setAttribute('stage', 'selected')

      // Kill all setTimeout handlers.
      jsPsych.pluginAPI.clearAllTimeouts();
      jsPsych.pluginAPI.cancelAllKeyboardResponses();

      // Record responses.
      response.key = info.key;
      console.log(info.key)
      response.rt = info.rt;
      if (response.key == key1) {
        response.choice_position = 0;
        response.card_choice = trial.card_decks[shuffled_positions[0]];
        response.points = parseInt(ordered_rewards[0]);
        console.log(rewards[0])
        display_element.querySelector('#card-deck-img-0').setAttribute('stage', 'selected')
        display_element.querySelector('#card-deck-back-img-0').setAttribute('stage', 'selected')
        display_element.querySelector('#card-deck-img-1').setAttribute('stage', 'not selected')
        display_element.querySelector('#card-deck-img-2').setAttribute('stage', 'not selected')
        display_element.querySelector('#card-deck-img-3').setAttribute('stage', 'not selected')
        if (response.points > 0){
          display_element.querySelector('#card-deck-text-0').setAttribute('stage', 'selected_pos')
          } else if (response.points < 0) {
          display_element.querySelector('#card-deck-text-0').setAttribute('stage', 'selected_neg') }
      } else if (response.key == key2) {
        response.choice_position = 1;
        response.card_choice = trial.card_decks[shuffled_positions[1]];
        response.points = parseInt(ordered_rewards[1]);
        display_element.querySelector('#card-deck-img-1').setAttribute('stage', 'selected')
        display_element.querySelector('#card-deck-back-img-1').setAttribute('stage', 'selected')
        display_element.querySelector('#card-deck-img-0').setAttribute('stage', 'not selected')
        display_element.querySelector('#card-deck-img-2').setAttribute('stage', 'not selected')
        display_element.querySelector('#card-deck-img-3').setAttribute('stage', 'not selected')
        if (response.points > 0){
        display_element.querySelector('#card-deck-text-1').setAttribute('stage', 'selected_pos')
        } else if (response.points < 0) {
        display_element.querySelector('#card-deck-text-1').setAttribute('stage', 'selected_neg') }
  
      } else if (response.key == key3) {
        response.choice_position = 2;
        response.card_choice = trial.card_decks[shuffled_positions[2]];
        response.points = parseInt(ordered_rewards[2]);
        console.log(rewards[2])
        display_element.querySelector('#card-deck-img-2').setAttribute('stage', 'selected')
        display_element.querySelector('#card-deck-back-img-2').setAttribute('stage', 'selected')
        display_element.querySelector('#card-deck-img-0').setAttribute('stage', 'not selected')
        display_element.querySelector('#card-deck-img-1').setAttribute('stage', 'not selected')
        display_element.querySelector('#card-deck-img-3').setAttribute('stage', 'not selected')
        if (response.points > 0){
          display_element.querySelector('#card-deck-text-2').setAttribute('stage', 'selected_pos')
          } else if (response.points < 0) {
          display_element.querySelector('#card-deck-text-2').setAttribute('stage', 'selected_neg') }
      } else if (response.key == key4) {
        response.choice_position = 3;
        response.card_choice = trial.card_decks[shuffled_positions[3]];
        response.points = parseInt(ordered_rewards[3]);
        console.log(rewards[3])
        display_element.querySelector('#card-deck-img-3').setAttribute('stage', 'selected')
        display_element.querySelector('#card-deck-back-img-3').setAttribute('stage', 'selected')
        display_element.querySelector('#card-deck-img-0').setAttribute('stage', 'not selected')
        display_element.querySelector('#card-deck-img-2').setAttribute('stage', 'not selected')
        display_element.querySelector('#card-deck-img-1').setAttribute('stage', 'not selected')
        if (response.points > 0){
          display_element.querySelector('#card-deck-text-3').setAttribute('stage', 'selected_pos')
          } else if (response.points < 0) {
          display_element.querySelector('#card-deck-text-3').setAttribute('stage', 'selected_neg') }
      }

      // end trial
      jsPsych.pluginAPI.setTimeout(function() {
        end_trial();
      }, trial.feedback_duration);
    };

    // Function to end trial when it is time
    var end_trial = function() {

      // Kill any remaining setTimeout handlers
      jsPsych.pluginAPI.clearAllTimeouts();
      jsPsych.pluginAPI.cancelAllKeyboardResponses();

      var trial_data = {
        "rt": response.rt,
        "card_choice": response.card_choice,
        "choice_position": response.choice_position,
        "points_earned": response.points,
      }
      // Clear the display
      display_element.innerHTML = '';

      // Move on to the next trial
      jsPsych.finishTrial(trial_data);

    };

    // ---------------------------------- //
    // Section 3: Run trial              //
    // ---------------------------------- //

      // Initialize first stage keyboardListener.
      var keyboardListener = "";
      setTimeout(function() {
        keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
          callback_function: after_response,
          valid_responses: trial.valid_choices,
          rt_method: 'performance',
          persist: false,
          allow_held_key: false
        });
      }, 0);    // No pause before keyboardListener.


    // End trial if no response.
    if (trial.choice_duration !== null) {
      jsPsych.pluginAPI.setTimeout(function() {
        missed_response();
      }, trial.choice_duration);
    }
  };


  return plugin;
})();
