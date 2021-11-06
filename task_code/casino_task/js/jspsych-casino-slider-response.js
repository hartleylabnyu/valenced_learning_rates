/**
 * jspsych-casino-slider-response
 * a jspsych plugin for free response survey questions
 *
 * Josh de Leeuw
 *
 * documentation: docs.jspsych.org
 *
 */


jsPsych.plugins['casino-slider-response'] = (function() {

  var plugin = {};

  plugin.info = {
    name: 'casino-slider-response',
    description: '',
    parameters: {
      stimulus: {
        type: jsPsych.plugins.parameterType.HTML_STRING,
        pretty_name: 'Stimulus',
        default: undefined,
        description: 'The HTML string to be displayed'
      },
      casino_background: {
        type: jsPsych.plugins.parameterType.IMG,
        pretty_name: 'Casino background',
        description: 'Background image',
        default: 'img/background1.png'
      },
      block: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Block',
        default: 1,
        description: "Block of task"
      },
      min: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Min slider',
        default: 0,
        description: 'Sets the minimum value of the slider.'
      },
      max: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Max slider',
        default: 100,
        description: 'Sets the maximum value of the slider',
      },
      start: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Slider starting value',
        default: 50,
        description: 'Sets the starting value of the slider',
      },
      step: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name: 'Step',
        default: 1,
        description: 'Sets the step of the slider'
      },
      labels: {
        type: jsPsych.plugins.parameterType.HTML_STRING,
        pretty_name:'Labels',
        default: [],
        array: true,
        description: 'Labels of the slider.',
      },
      slider_width: {
        type: jsPsych.plugins.parameterType.INT,
        pretty_name:'Slider width',
        default: null,
        description: 'Width of the slider in pixels.'
      },
      button_label: {
        type: jsPsych.plugins.parameterType.STRING,
        pretty_name: 'Button label',
        default:  'Submit',
        array: false,
        description: 'Label of the button to advance.'
      },
      require_movement: {
        type: jsPsych.plugins.parameterType.BOOL,
        pretty_name: 'Require movement',
        default: true,
        description: 'If true, the participant will have to move the slider before continuing.'
      },
      prompt: {
        type: jsPsych.plugins.parameterType.HTML,
        pretty_name: 'Prompt',
        default: null,
        description: 'Any content here will be displayed below the slider.'
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
        description: 'How long to show the trial.'
      },
      response_ends_trial: {
        type: jsPsych.plugins.parameterType.BOOL,
        pretty_name: 'Response ends trial',
        default: true,
        description: 'If true, trial will end when user makes a response.'
      },
    }
  }

  plugin.trial = function(display_element, trial) {

      // ---------------------------------- //
    // Section 1: Define HTML             //
    // ---------------------------------- //

    // Define HTML
    var new_html = '';

    // Start casino wrapper.
    new_html += `<div class="casino-wrap" block=${trial.block}>`;

    // Start casino container
    new_html += '<div class="casino-single">';

    // Start deck container 
    new_html += `<div class="card-deck" id="card-deck" >`;

    // Draw card image
    new_html += ` <img src="${trial.stimulus}" id="card-deck-img" class="card-deck-img" stage="1">`;

    // Finish deck container
    new_html += '</div>'; 

    // Close casino container.
    new_html += '</div>';

    // draw slider
    new_html += '<input type="range" value="'+trial.start+'" min="'+trial.min+'" max="'+trial.max+'" step="'+trial.step+'" style="width: 60%;" id="jspsych-casino-slider-response-response"></input>';
    new_html += '<div>'
    for(var j=0; j < trial.labels.length; j++){
      var width = 60/(trial.labels.length-1);
      var left_offset = (j * (60 /(trial.labels.length - 1))) - (width/2);
      new_html += '<div style="left:'+left_offset+'%; text-align: center; width: '+width+'%;">';
      new_html += '<span style="text-align: center; font-size: 80%;">'+trial.labels[j]+'</span>';
      new_html += '</div>'
    }
    new_html += '</div>';

    if (trial.prompt !== null){
      new_html += trial.prompt;
    }

    // add submit button
    new_html += '<button id="jspsych-casino-slider-response-next" class="jspsych-btn" '+ (trial.require_movement ? "disabled" : "") + '>'+trial.button_label+'</button>';


    // Close casino wrapper.
    new_html += '</div>';
    



    display_element.innerHTML =  new_html;

    var response = {
      rt: null,
      response: null
    };
    
    if(trial.require_movement){
      display_element.querySelector('#jspsych-casino-slider-response-response').addEventListener('change', function(){
        display_element.querySelector('#jspsych-casino-slider-response-next').disabled = false;
      })
    }

    display_element.querySelector('#jspsych-casino-slider-response-next').addEventListener('click', function() {
      // measure response time
      var endTime = performance.now();
      response.rt = endTime - startTime;
      response.response = display_element.querySelector('#jspsych-casino-slider-response-response').value;

      if(trial.response_ends_trial){
        end_trial();
      } else {
        display_element.querySelector('#jspsych-casino-slider-response-next').disabled = true;
      }

    });

    function end_trial(){

      jsPsych.pluginAPI.clearAllTimeouts();

      // save data
      var trialdata = {
        "rt": response.rt,
        "response": response.response,
        "stimulus": trial.stimulus
      };

      display_element.innerHTML = '';

      // next trial
      jsPsych.finishTrial(trialdata);
    }

    if (trial.stimulus_duration !== null) {
      jsPsych.pluginAPI.setTimeout(function() {
        display_element.querySelector('#jspsych-casino-slider-response-stimulus').style.visibility = 'hidden';
      }, trial.stimulus_duration);
    }

    // end trial if trial_duration is set
    if (trial.trial_duration !== null) {
      jsPsych.pluginAPI.setTimeout(function() {
        end_trial();
      }, trial.trial_duration);
    }

    var startTime = performance.now();
  };

  return plugin;
})();
