/**
 * jspsych-casino-comp_q
 * modified from jspsych-html-comp_q
 *
 **/


jsPsych.plugins["casino-comp_q"] = (function() {

  var plugin = {};

  plugin.info = {
    name: 'casino-comp_q',
    description: '',
    parameters: {
      block: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Block',
        default: 1,
        description: "Block of task"
      },
      stimulus: {
        type: jsPsych.plugins.parameterType.HTML_STRING,
        pretty_name: 'Stimulus',
        default: undefined,
        description: 'The HTML string to be displayed'
      },
      audio: {
        type: jsPsych.plugins.parameterType.audio,
        pretty_name: 'Audio',
        default: undefined,
        description: 'The audio file to be played'
      },
      choices: {
        type: jsPsych.plugins.parameterType.KEYCODE,
        array: true,
        pretty_name: 'Choices',
        default: jsPsych.ALL_KEYS,
        description: 'The keys the subject is allowed to press to respond to the stimulus.'
      },
      stimulus_duration: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Stimulus duration',
        default: null,
        description: 'How long to hide the stimulus.'
      },
      trial_duration: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Trial duration',
        default: null,
        description: 'How long to show trial before it ends.'
      },
      continue_delay: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Continue delay',
        default: 1500,
        description: 'How long to wait before showing continue message.'
      },
      response_ends_trial: {
        type: jsPsych.plugins.parameterType.BOOL,
        pretty_name: 'Response ends trial',
        default: true,
        description: 'If true, trial will end when subject makes a response.'
      },

    }
  }

  plugin.trial = function(display_element, trial) {

    // Define HTML
    var new_html = '';

    // Start casino wrapper and write text. 
    new_html += `<div class="casino-wrap" block=${trial.block}> <div id="jspsych-casino-comp_q-stimulus" class="instructions-text"> ${trial.stimulus} </div>
    <div id="trial-continue-message" class="continue-message" stage="hidden"> Press <b>t</b> for TRUE and <b>f</b> for 'FALSE'. </div></div>`;

     // setup audio
     var context = jsPsych.pluginAPI.audioContext();
     if(context !== null){
       var source = context.createBufferSource();
       source.buffer = jsPsych.pluginAPI.getAudioBuffer(trial.audio);
       source.connect(context.destination);
     } else {
       var audio = jsPsych.pluginAPI.getAudioBuffer(trial.audio);
       audio.currentTime = 0;
     }

    // draw
    display_element.innerHTML = new_html;

    // store response
    var response = {
      rt: null,
      key: null
    };

    // function to end trial when it is time
    var end_trial = function() {

       // stop the audio file if it is playing
			// remove end event listeners if they exist
			if(context !== null){
				source.stop();
				source.onended = function() { }
			} else {
				audio.pause();
				audio.removeEventListener('ended', end_trial);
			}


      // kill any remaining setTimeout handlers
      jsPsych.pluginAPI.clearAllTimeouts();

      // kill keyboard listeners
      if (typeof keyboardListener !== 'undefined') {
        jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);
      }

      // gather the data to store for the trial
      var trial_data = {
        "rt": response.rt,
        "stimulus": trial.stimulus,
        "key_press": response.key
      };

      // clear the display
      display_element.innerHTML = '';

      // move on to the next trial
      jsPsych.finishTrial(trial_data);
    };

    // function to handle responses by the subject
    var after_response = function(info) {

      // after a valid response, the stimulus will have the CSS class 'responded'
      // which can be used to provide visual feedback that a response was recorded
      display_element.querySelector('#jspsych-casino-comp_q-stimulus').className += ' responded';

      // only record the first response
      if (response.key == null) {
        response = info;
      }

      if (trial.response_ends_trial) {
        end_trial();
      }
    };

    // display continue message
      jsPsych.pluginAPI.setTimeout(function() {
        display_element.querySelector('#trial-continue-message').setAttribute('stage', 'visible')
      }, trial.continue_delay);
    

    // start the response listener
    if (trial.choices != jsPsych.NO_KEYS) {
      var keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
        callback_function: after_response,
        valid_responses: trial.choices,
        rt_method: 'performance',
        persist: false,
        allow_held_key: false
      });
    }

    	// start audio
      if(context !== null){
        startTime = context.currentTime;
        source.start(startTime);
      } else {
        audio.play();
      }

    // hide stimulus if stimulus_duration is set
    if (trial.stimulus_duration !== null) {
      jsPsych.pluginAPI.setTimeout(function() {
        display_element.querySelector('#jspsych-casino-comp_q-stimulus').style.visibility = 'hidden';
      }, trial.stimulus_duration);
    }

    // end trial if trial_duration is set
    if (trial.trial_duration !== null) {
      jsPsych.pluginAPI.setTimeout(function() {
        end_trial();
      }, trial.trial_duration);
    }

  };

  return plugin;
})();
