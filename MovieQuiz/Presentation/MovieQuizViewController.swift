import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    // для состояния "Вопрос задан"
   private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // для состояния "Результат квиза"
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
   private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    private var questions: [QuizQuestion] = [
        QuizQuestion(image:"The Godfather" , text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image:"The Dark Knight" , text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image:"Kill Bill" , text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image:"The Avengers" , text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image:"Deadpool" , text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image:"The Green Knight" , text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image:"Old" , text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image:"The Ice Age Adventures of Buck Wild" , text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image:"Tesla" , text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image:"Vivarium" , text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
        
    ]
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        // Попробуйте написать код конвертации сами
      
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данным
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(
                title: result.title,
                message: result.text,
                preferredStyle: .alert)
            
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                // заново показываем первый вопрос
                let firstQuestion = self.questions[self.currentQuestionIndex]
                let viewModel = self.convert(model: firstQuestion)
                self.show(quiz: viewModel)
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        noButton.isEnabled = false
        yesButton.isEnabled = false
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        // радиус скругления углов рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor// делаем рамку белой
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
          
        }
        
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
        // показать результат квиза
          let text = "\(correctAnswers) из 10"
          let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "сыграть еще раз")
          show(quiz: viewModel)
          
      } else {
        currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
        // показать следующий вопрос
          let nextQuestion = questions[currentQuestionIndex]
          let viewModel = convert(model: nextQuestion)
          show(quiz: viewModel)
          
      }
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
}










/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
