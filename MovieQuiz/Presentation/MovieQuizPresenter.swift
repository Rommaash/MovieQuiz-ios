import Foundation
import UIKit

final class MovieQuizPresenter {
    private weak var viewController: MovieQuizViewController?
        private var questionFactory: QuestionFactoryProtocol?
        private var statisticService: StatisticService?
        private var currentQuestion: QuizQuestion?
        var alertPresenter: AlertPresenter?
    
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
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
