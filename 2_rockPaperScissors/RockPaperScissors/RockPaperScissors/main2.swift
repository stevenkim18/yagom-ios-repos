import Foundation

enum Player {
    case computer
    case user
    case none
    
    mutating func toggle() {
        switch self {
        case .computer:
            self = .user
        case .user:
            self = .computer
        default:
            break
        }
    }
}

enum GameNotice {
    static func printScissorsRockPaper() {
        print("가위(1), 바위(2), 보(3)! <종료 : 0>", terminator: " : ")
    }
    
    static func printTheEnd() {
        print("게임 종료")
    }
    
    static func printRockScissorsPaper(turn: Player) {
        switch turn {
        case .computer:
            print("[컴퓨터 턴] 묵(1), 찌(2), 빠(3)! <종료 : 0>", terminator: " : ")
        default:
            print("[사용자 턴] 묵(1), 찌(2), 빠(3)! <종료 : 0>", terminator: " : ")
        }
    }
    
    static func printWrongInputError() {
        print("잘못된 입력입니다. 다시 입력해주세요.")
    }
    
    static func printCurrentTurn(currentTurn: Player) {
        switch currentTurn {
        case .computer:
            print("컴퓨터의 턴입니다")
        default:
            print("사용자의 턴입니다")
        }
    }
    
    static func printResultOfScissorsRockPaper(matchResult: MatchResult) {
        switch matchResult {
        case .computerWins:
            print("졌습니다!")
        case .userWins:
            print("이겼습니다!")
        case .draw:
            print("비겼습니다!")
        default:
            break
        }
    }
    
    static func printWinner(winner: Player) {
        switch winner {
        case .computer:
            print("컴퓨터의 승리!")
        case .user:
            print("사용자의 승리!")
        default:
            break
        }
    }
}

enum MatchResult {
    case computerWins
    case userWins
    case draw
    case stop
}

enum PlayerOption {
    case scissor
    case rock
    case paper
    case stop
    case none
    
    init(_ number: String) {
        switch number {
        case "0":
            self = .stop
        case "1":
            self = .scissor
        case "2":
            self = .rock
        case "3":
            self = .paper
        default:
            self = .none
        }
    }
    
    init(_ number: Int) {
        switch number {
        case 0:
            self = .stop
        case 1:
            self = .scissor
        case 2:
            self = .rock
        case 3:
            self = .paper
        default:
            self = .none
        }
    }
}

func runProgram() {
    startGame()
    GameNotice.printTheEnd()
}

func startGame() {
    // userWannaExit만 봤을 때 bool 타입 변수 라는 느낌이 안와요!
    // 어떻게 바꿀 수 있을까요?
    // isContinuing? canExit?
    // https://soojin.ro/blog/naming-boolean-variables 여기를 참고하면서 생각해보시면 좋을 것 같아요!
    let (firstTurn, userWannaExit) = decideFirstTurn()
    
    guard userWannaExit == false else { return }
    
    playRockScissorsPaper(firstTurn: firstTurn)
}

func playRockScissorsPaper(firstTurn: Player) {
    var currentTurn = firstTurn
    // PlayerOption에 none case를 만드셨는데 굳이 필요한건지..
    // 그냥 초기화를 위한거라면 타입을 명시해주는 게 더 좋을 것 같은데...
    var userOption = PlayerOption.none
    
    // 전반적으로 Option이라는 단어가 느낌이 오지는 않는다 userChoice userHand 이런 단어는 어떨까?
    while true {
        userOption = decideUserOption(currentTurn: &currentTurn)
        
        if userOption == PlayerOption.stop { return }
        
        let computerOption = generateRandomHand()
        
        if userOption == computerOption { break }
        
        currentTurn.toggle()
        
        GameNotice.printCurrentTurn(currentTurn: currentTurn)
    }
    
    GameNotice.printWinner(winner: currentTurn)
}

// inout을 사용하셨네요? 어떤 경우에 사용하나요? 사용할 때랑 안할 때의 차이는 무엇인가요?
func decideUserOption(currentTurn: inout Player) -> PlayerOption {
    var isValidateOption = false
    var playerOption: PlayerOption = .none
    
    while isValidateOption == false {
        GameNotice.printRockScissorsPaper(turn: currentTurn)
        
        (playerOption, isValidateOption) = receiveUsersInput()
        
        if isValidateOption == true { break }
        
        currentTurn = Player.computer
        
        GameNotice.printCurrentTurn(currentTurn: currentTurn)
    }
    
    return playerOption
}

func decideFirstTurn() -> (Player, Bool) {
    var matchResult: MatchResult
    
    repeat {
        matchResult = playScissorsRockPaper()
    } while matchResult == .draw
    
    let firstTurn = decideWinnerOfScissorsRockPaper(from: matchResult)
    // 삼항 연산자를 사용하셨네요? 여기서는 들여쓰기 제약도 없으신데 쓰신 이유는 무엇인가요?
    // 삼항 연산자를 사용하면 어떤 장단점이 있을까요?
    let userWannaExit = (matchResult == .stop) ? true : false
    
    return (firstTurn, userWannaExit)
}

func playScissorsRockPaper() -> MatchResult {
    GameNotice.printScissorsRockPaper()
    
    let computersHand: PlayerOption = generateRandomHand()
    var (usersHand, isValidInput) = receiveUsersInput()
    
    while isValidInput == false {
        GameNotice.printWrongInputError()
        GameNotice.printScissorsRockPaper()
        (usersHand, isValidInput) = receiveUsersInput()
    }
    
    guard usersHand != .stop else {
        return MatchResult.stop
    }
    
    let matchResult = decideMatchResult(between: computersHand, and: usersHand)
    
    GameNotice.printResultOfScissorsRockPaper(matchResult: matchResult)
    return matchResult
}

func decideWinnerOfScissorsRockPaper(from matchResult: MatchResult) -> Player {
    switch matchResult {
    case .computerWins:
        return .computer
    case .userWins:
        return .user
    default:
        return .none
    }
}

// 이부분은 Hand enum타입의 함수로 만들 수 있지 않을까 싶다.
// Hand.generateRandomHand()
func generateRandomHand() -> PlayerOption {
    let randomNumber: Int = Int.random(in: 1...3)
    
    return PlayerOption(randomNumber)
}

func receiveUsersInput() -> (PlayerOption, Bool) {
    guard let userInput = readLine() else {
        return (.none, false)
    }
    
    let isValidInput = verify(userInput: userInput)
    let usersHand = PlayerOption(userInput)
    
    return (usersHand, isValidInput)
}

func convertToInteger(from userInput: String) -> Int? {
    return Int(userInput)
}

func verify(userInput: String) -> Bool {
    guard let integerUserInput = convertToInteger(from: userInput) else {
        return false
    }
    
    return (0...3).contains(integerUserInput)
}

func decideMatchResult(between computersHand: PlayerOption, and usersHand: PlayerOption) -> MatchResult {
    if computersHand == usersHand {
        return MatchResult.draw
    }
    
    switch (computersHand, usersHand) {
    case (.rock, .scissor), (.scissor, .paper), (.paper, .rock):
        return MatchResult.computerWins
    case (.rock, .paper), (.scissor, .rock), (.paper, .scissor):
        return MatchResult.userWins
    default:
        return MatchResult.draw
    }
}

runProgram()
