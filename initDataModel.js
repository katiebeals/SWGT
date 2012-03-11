// Lesson Number
currentLessonNumber = 1;
// Exercise Number
currentExerciseNumber = 1;

// Words for the current answer
currentAnswer = "";
// Current word being dragged
currentWord = "";

// Redo mode
redoMode = false;
// An array of incorrectly answered prompts to redo
promptsToRedo = new Array();
// Current redo prompt track
currentRedoPromptNumber = 0;

// Array of answer words
currentAnswerWords = new Array();
draggableAnswerWords = new Array();

// Randomly sorted questions
randomizedQuestions = new Array();
randomizedAnswers = new Array();
randomizedMultipleChoices = new Array();
randomizedLessonVideos = new Array();
randomizedPronounNounLists = new Array();

// Randomize the questions in lesson 1
var randomLength = Number(lessonQuestions[0].length);
var randomNumberArray = new Array();

// Create an array of numbers in numerical order
for( var a = 0; a < randomLength; a++ )
{
	randomNumberArray.push(a);
}
// Then, shuffle the numbers
randomNumberArray.sort(function() {return 0.5 - Math.random()});

// Randomize the questions, answers, multiple choices, and vidoes
for( var b = 0; b < randomLength; b++ )
{
	//alert("Picked number: " + randomNumberArray[b]);
	randomizedQuestions.push(String(lessonQuestions[0][randomNumberArray[b]]));
	//alert("Latest question: " + randomizedQuestions[randomizedQuestions.length - 1]);
	randomizedAnswers.push(lessonAnswers[0][randomNumberArray[b]]);
	//alert("Latest answer: " + randomizedAnswers[randomizedAnswers.length - 1]);
	randomizedMultipleChoices[b] = new Array();
	for( var b2 = 0; b2 < 4; b2++ )
	{
		randomizedMultipleChoices[b][b2] = String(multipleChoices[0][randomNumberArray[b]][b2]);
	}
	//alert("Latest multiple choices: " + randomizedMultipleChoices[randomizedMultipleChoices.length - 1]);
	randomizedLessonVideos.push(String(lessonVideos[0][randomNumberArray[b]]));
	//alert("Latest video: " + randomizedLessonVideos[randomizedLessonVideos.length - 1]);
	randomizedPronounNounLists.push(lessonPronounNounLists[0][randomNumberArray[b]]);
}

// Dot Array
dotMatrix = new Array();
for( var c = 0; c < randomizedQuestions.length; c++ )
{
	dotMatrix[c] = DOT_INCOMPLETE;
}

// Load the video

// document.write("<video autoplay=\"autoplay\" controls=\"controls\" id=\"video\" width=\"533\" height=\"300\" src=" + randomizedLessonVideos[0] + "></video>");

NativeBridge.call("printNative", ["initDataModel:",randomizedLessonVideos[0],"three"]);


$("#video_box").append("<video autoplay=\"autoplay\" controls=\"controls\" id=\"video\" width=\"533\" height=\"300\" src=" + randomizedLessonVideos[0] + "></video>");

// Load the dots (the context needs to be the dotContainer element)
for( var d = 0; d < dotMatrix.length; d++ )
{
	if( (d % 6 == 0) && (d != 0) )
	{
		//document.write("<br />");
		//document.write("<img class=\"dotImage\" src=\"img/yellowDot.png\" />");
		
		// $("#video").attr("src", randomizedLessonVideos[currentExerciseNumber - 1]);
		
		$("#dotContainer").append("<br />");
		$("#dotContainer").append("<img class=\"dotImage\" src=\"img/yellowDot.png\" />");
		
	}
	else
	{
		// document.write("<img class=\"dotImage\" src=\"img/yellowDot.png\" />");
		$("#dotContainer").append("<img class=\"dotImage\" src=\"img/yellowDot.png\" />");
		
	}
}

// Load multiple choices (the context is presentedChoices)


for(var answerChoice = 0; answerChoice < randomizedMultipleChoices[currentExerciseNumber-1].length; answerChoice++)
{
    //document.write("<p>" + randomizedMultipleChoices[currentExerciseNumber-1][answerChoice] + "</p>");
    
	$("#presentedChoices").append("<p>" + randomizedMultipleChoices[currentExerciseNumber-1][answerChoice] + "</p>");
    
}



appLoaded();

