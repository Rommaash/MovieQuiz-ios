import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var presenter = MovieQuizPresenter()
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
    private func showNetworkError(message: String){
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз")
        { [weak self] in
            guard let self = self else {return}
            self.presenter.restartGame()
            self.questionFactory?.loadData()
        }
        alertPresenter?.showAlert(model: model)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    

    
    
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion(){
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            let totalAccuracyPercentage = (String(format: "%.2f", statisticService.totalAccuracy) + "%")
            let bestGameDate = statisticService.bestGame.date.dateTimeString
            let totalGamesCount = statisticService.gamesCount
            let currentCorrectRecord = statisticService.bestGame.correct
            let currentTotalRecord = statisticService.bestGame.total
            let text = """
                           Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
                           Количество сыгранных квизов: \(totalGamesCount)
                           Рекорд: \(currentCorrectRecord)/\(currentTotalRecord) (\(bestGameDate)
                           Средняя точность: \(totalAccuracyPercentage)
                           """
            
            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть еще раз",
                completion: { [weak self] in
                    guard let self = self else {return}
                    self.presenter.restartGame()
                    print("end")
                })
            alertPresenter?.showAlert(model: viewModel)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        noButton.isEnabled = false
        yesButton.isEnabled = false
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            
        }
        
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        questionFactory?.loadData()
        alertPresenter = AlertPresenter(delegate: self)
    }
    
}



