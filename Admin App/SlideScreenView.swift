import SwiftUI
import AVKit

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill

        let view = UIView()
        view.layer.addSublayer(playerLayer)

        playerLayer.frame = view.bounds
        playerLayer.masksToBounds = true

        // Observe the end of the video to loop it
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer else { return }
        playerLayer.frame = uiView.bounds
    }
}

struct SlideScreenView: View {
    static let url = Bundle.main.url(forResource: "backgroundfile", withExtension: "m4v")!
    @State private var avplayer = AVPlayer(url: SlideScreenView.url)
    @State private var isNavigating = false

    init() {
        avplayer.isMuted = true
        avplayer.play()
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VideoPlayerView(player: avplayer)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    TabView {
                        Image("png1") // Replace with your image name
                            .resizable() // Make the image resizable
                            .scaledToFit() // Scale the image to fill the view
                           // .background(Color("imageBackground").ignoresSafeArea())
                        
                        Image("png2")
                            .resizable() // Make the image resizable
                            .scaledToFit()
                            //.background(Color("imageBackground").ignoresSafeArea())
                        
                        ZStack(alignment: .bottom) {
                            Image("png3")
                                .resizable() // Make the image resizable
                                .scaledToFit()
                                //.background(Color("imageBackground").ignoresSafeArea())
                            
                            NavigationLink(destination: LoginScreen(), isActive: $isNavigating) {
                                CustomButton(label: "Welcome", action: {
                                    isNavigating = true
                                })
                            }.padding(.bottom,30)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                }
                .padding(.top, 40)
                .navigationBarBackButtonHidden(true)
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(
                    self,
                    name: .AVPlayerItemDidPlayToEndTime,
                    object: avplayer.currentItem
                )
            }
        }
    }
}

#Preview {
    SlideScreenView()
}
