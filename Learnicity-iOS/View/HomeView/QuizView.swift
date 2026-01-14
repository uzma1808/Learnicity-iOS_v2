//
//  QuizView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 28/09/2025.
//

import SwiftUI

struct QuizView: View {
    @ObservedObject var vm = HomeView.HomeViewModel()
    @State private var showNext = false
    private let optionColors: [Color] = [.red, .blue, .green, .yellow]
    @State private var showConfetti = false

    var body: some View {
        if vm.startQuiz {
            VStack(spacing: 24) {
                if vm.isLoading {
                    ProgressView("Loading quiz...")
                } else if vm.showError {
                    Text(vm.errorMessage ?? "Something went wrong")
                        .foregroundColor(.red)
                } else {
                    if let tf = vm.trueFalseQuiz, vm.currentIndex == 0 {
                        // --- True/False Quiz ---
                        VStack(spacing: 16) {
                            Spacer()
                            Text(tf.question ?? "")
                                .customFont(style: .bold, size: .h28)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            HStack(spacing: 40) {
                                Button {
                                    checkTrueFalse(answer: true, correct: tf.answer ?? false, id: tf.id ?? 0)
                                    goNext()
                                } label: {
                                    Text("True")
                                        .customFont(style: .black, size: .h35)
                                        .foregroundColor(.white)
                                        .frame(width: 120, height: 120)
                                        .background(Color.green)
                                        .clipShape(Circle())
                                }

                                Button {
                                    checkTrueFalse(answer: false, correct: tf.answer ?? false, id: tf.id ?? 0)
                                    goNext()
                                } label: {
                                    Text("False")
                                        .customFont(style: .black, size: .h35)
                                        .foregroundColor(.white)
                                        .frame(width: 120, height: 120)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                }
                            }
                            Spacer()
                        }
                    } else if vm.currentIndex > 0 && vm.currentIndex <= vm.mcqQuizzes.count {
                        let mcq = vm.mcqQuizzes[vm.currentIndex - 1]
                        VStack(spacing: 16) {
                            Spacer()
                            Text(mcq.question ?? "")
                                .customFont(style: .medium, size: .h24)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            VStack(spacing: 12) {
                                quizOptionButton(index: 0, text: mcq.option1 ?? "", correct: mcq.correct_option ?? "", id: mcq.id ?? 0)
                                quizOptionButton(index: 1, text: mcq.option2 ?? "", correct: mcq.correct_option ?? "", id: mcq.id ?? 0)
                                quizOptionButton(index: 2, text: mcq.option3 ?? "", correct: mcq.correct_option ?? "", id: mcq.id ?? 0)
                                quizOptionButton(index: 3, text: mcq.option4 ?? "", correct: mcq.correct_option ?? "", id: mcq.id ?? 0)
                            }
                            Spacer()
                        }
                    } else {
                        ZStack {
                                    VStack(spacing: 20) {
                                        Spacer()

                                        if let coins = vm.coinsEarned {
                                            if coins == 0 {
                                                VStack {
                                                    Image(.fail)
                                                        .resizable()
                                                        .frame(width: 150, height: 150)
                                                    Text("You have failed quiz!\nYou earned \(coins) coins")
                                                        .customFont(style: .bold, size: .h30)
                                                        .multilineTextAlignment(.center)
                                                }
                                            } else {
                                                VStack {
                                                    Image(.reward)
                                                        .resizable()
                                                        .frame(width: 150, height: 150)
                                                    Text("Congratulations!\nYou earned \(coins) coins")
                                                        .customFont(style: .bold, size: .h30)
                                                        .multilineTextAlignment(.center)
                                                }
                                                .onAppear {
                                                    showConfetti = true
                                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                                }
                                            }

                                            CustomButtonView(title: "Take Another Quiz") {
                                                vm.resetQuiz()
                                            }
                                            .padding(.horizontal, 17)
                                        }

                                        Spacer()
                                    }

                                    // 🎉 Confetti Overlay
//                                    if showConfetti {
//                                        LottieView(name: "confettie", loopMode: .playOnce) {
//                                            // Hide confetti after animation finishes
//                                            withAnimation(.easeOut(duration: 0.3)) {
//                                                showConfetti = false
//                                            }
//                                        }
//                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                        .background(Color.black.opacity(0.001)) // ensures tap passthrough
//                                        .ignoresSafeArea()
//                                        .transition(.opacity)
//                                        .zIndex(1) // keep above everything
//                                    }
                                }

                    }
                }
            }
            .padding(.horizontal)
            .task {
                await vm.fetchQuiz()
            }
        } else {
            VStack {
                Image(.animal)
                    .resizable()
                    .frame(width: 150, height: 183)
                Text("Ready to Learn & Earn")
                    .customFont(style: .black, size: .h30)
                CustomButtonView(title: "Let’s Go!", action: {
                    vm.startQuiz = true
                })
                .padding(.horizontal, 17)
            }
            .padding(.top, 30)
        }
        
    }

    // MARK: - Helpers

    private func checkTrueFalse(answer: Bool, correct: Bool, id: Int) {
        vm.selectedTrueFalse = SubmitTrueFalse(id: id, answer: answer)
        goNext()
    }

    @ViewBuilder
    private func quizOptionButton(index: Int, text: String, correct: String, id: Int) -> some View {
        Button {
            vm.selectedMCQs.append(SubmitMCQ(id: id, answer: text))
            goNext()
        } label: {
            Text(text)
                .customFont(style: .medium, size: .h24)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(optionColors[index % optionColors.count])
                .cornerRadius(12)
        }
    }


    private func colorForOption(_ text: String) -> Color {
        switch text.hashValue % 4 {
        case 0: return .red
        case 1: return .yellow
        case 2: return .blue
        default: return .green
        }
    }

    private func goNext() {
        withAnimation {
            if vm.currentIndex < (1 + vm.mcqQuizzes.count) {
                vm.currentIndex += 1
            }

            // ✅ If we've passed all questions -> submit quiz
            if vm.currentIndex > vm.mcqQuizzes.count {
                Task {
                    await vm.submitQuiz()
                }
            }
        }
    }

}



#Preview {
    QuizView()
}
