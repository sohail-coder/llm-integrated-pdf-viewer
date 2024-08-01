import SwiftUI
import Firebase
import GoogleSignIn

enum NavigationDestination: Hashable {
//    case welcome
    case skipped
}

struct SignInView: View {
    @State private var navigationPath = NavigationPath()
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack{
                Color.loginBackground.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text("Welcome!")
                        .font(.custom("PlaywriteDKLoopet-Regular", size: 36))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        
                        
                    Spacer()
                    Image("loginBackground").resizable().aspectRatio(contentMode: .fit)
                    Spacer()
                    Text("Please login to continue").font(.system(size: 15)).opacity(0.6).foregroundStyle(.white)
                    Button(action: signInWithGoogle, label: {
                        HStack{
                            Image("ios_neutral_rd_SI").resizable()
                                .frame(width: 200,height: 55)
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                                .font(.largeTitle)
                            
                        }
                        
                        
                    })
                    .padding()
                    
                    Button(action: skipForNow) {
                        Text("Skip for Now")
//                            .fontWeight(.semibold)
                            .font(.system(size: 18))
                            .padding()
                            .foregroundColor(.white)
                            
                            .opacity(0.7)
                    }
                    
                    Spacer()
                }
            }
         
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
//                case .welcome:
//                    WelcomeView()
                case .skipped:
                    SkipView()
                }
            }
        }
    }
    
    func signInWithGoogle() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        
//        let config = GIDConfiguration(clientID: clientID)
        let additionalScopes = ["https://www.googleapis.com/auth/drive.file"]
        // Correct usage of Google Sign-In with SwiftUI
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController(), hint: nil, additionalScopes: additionalScopes) { user, error in
            if let error = error {
                print("Error signing in with Google: \(error.localizedDescription)")
                return
            }
            
            guard let authentication = user?.user, let idToken = authentication.idToken?.tokenString else {
                print("Error retrieving Google authentication token")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error signing in with Firebase: \(error.localizedDescription)")
                    return
                }
                
                // User is signed in with Firebase
                print("Successfully signed in with Firebase: \(String(describing: authResult?.user))")
//                navigationPath.append(NavigationDestination.welcome)
            }
        }
        
    }
    
    func skipForNow() {
        navigationPath.append(NavigationDestination.skipped)
    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = screen.windows.first?.rootViewController else {
            return UIViewController()
        }
        return rootViewController
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
