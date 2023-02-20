import Foundation
import UIKit

final class MovieQuizPresenter {
 weak var viewController: MovieQuizViewController?
        private var questionFactory: QuestionFactoryProtocol?
        private var statisticService: StatisticService?
 var currentQuestion: QuizQuestion?
        var alertPresenter: AlertPresenter?
    
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = true
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = false
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
  func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    

}
