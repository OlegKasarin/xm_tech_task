# Survey app
A simple Survey app written in SwiftUI

# Tech stack:
- Swift
- SwiftUI
- Swift Concurrency

Unit tests:
- I used Sourcery;
- For SUI unit tests I would use ViewInspector.

# Spec:
The app consists of two screens:
1. Initial screen with "Start survey" button. Pressing the button will load the second screen that will display the list of survey questions.

2. Questions screen with a horizontal pager of all the questions.
- Pressing previous and next buttons moves to the previous and next question.
Previous button should be disabled when on the 1st question and the next button
should be disabled when on the last question.
- Pressing the submit button posts the request to the server. Submit button is
disabled when no answer text exists or when the answer has been already
answered.
- A counter of already submitted questions exists on top of every question. It should
be updated dynamically after every successful question submission.

Note: tapping back (going to the Initial screen) and then tapping “Start survey” should restart the survey with 0 answered questions.

Submit a question
Submit question endpoint can:
- (1) Succeed with a 200 status response
- (2) Fail with a 400 status response

Upon success (1), a notification banner should appear for some seconds with text: “Success!”
Upon failure (2), a notification banner should appear for some seconds with text: “Failure....” and a retry button!

Successful submission of questions should be kept in memory so that when navigating to an already submitted question, the submitted answer will be present and the submit button will be disabled.

Note: This does not imply any offline storage. It “only” means that the question submission status is kept in memory while you navigate back and forth amongst the questions.