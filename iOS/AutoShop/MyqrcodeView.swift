import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct MyqrcodeView: View {
    let uid: String
    @State private var isPaymentSetupNoticePresented = false
    @State private var isActivePaymentView = false
    @State private var isActiveCartView = false
    @State private var isInfoButtonTapped = false // Added state for info button

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                VStack {
                    Text("My QR Code")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                        .fontWeight(.bold)

                    ZStack(alignment: .center) {
                        generateQRCode(from: uid)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300, alignment: .center)
                            .padding(.trailing, 00) // Adjust the padding here to move the QR code right

                        // Info Button
                        Button(action: {
                            isInfoButtonTapped.toggle()
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: 120, y: 120)
                        .sheet(isPresented: $isInfoButtonTapped) {
                            PaymentSetupNoticeView()
                        }
                    }
                    .padding(.horizontal) // Add horizontal padding for center alignment
                    .padding(.top, 20)

                    Text("掃一掃進入AutoShop")
                        .font(.system(size: 18, weight: .bold)) // Adjust the size as needed
                        .foregroundColor(.black)
                        .padding(.top, 20)
                        .fontWeight(.bold)
                }
                .padding()

                Spacer()

                HStack {
                    Spacer()

                    Button(action: {
                        // Handle QR Code button action
                    }) {
                        VStack {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.title)
                                .foregroundColor(.blue)
                            Text("QR Code")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(10)

                    Spacer()

                    Button(action: {
                        isActivePaymentView = true
                        isActiveCartView = false
                    }) {
                        VStack {
                            Image(systemName: "creditcard.fill")
                                .font(.title)
                                .foregroundColor(isActivePaymentView ? .blue : .gray)
                            Text("付款設定")
                                .font(.footnote)
                                .foregroundColor(isActivePaymentView ? .blue : .gray)
                        }
                        .padding()
                    }
                    .background(NavigationLink("", destination: PaymentView(), isActive: $isActivePaymentView))

                    Spacer()

                    Button(action: {
                        isActiveCartView = true
                        isActivePaymentView = false
                    }) {
                        VStack {
                            Image(systemName: "cart.fill")
                                .font(.title)
                                .foregroundColor(isActiveCartView ? .blue : .gray)
                            Text("購物車")
                                .font(.footnote)
                                .foregroundColor(isActiveCartView ? .blue : .gray)
                        }
                        .padding()
                    }
                    .background(NavigationLink("", destination: CartView(), isActive: $isActiveCartView))
                    .cornerRadius(10)

                    Spacer()
                }
                .padding(.bottom, 10)
            }
            .background(Image("bg").resizable().scaledToFill())
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $isPaymentSetupNoticePresented) {
                PaymentSetupNoticeView()
            }
            .navigationBarHidden(true) // Hide the default navigation bar
        }
    }

    // Generate QR code using UIImage and CIFilter
    func generateQRCode(from string: String) -> Image {
        let data = Data(string.utf8)

        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else {
            return Image(systemName: "xmark.circle")
        }

        qrFilter.setValue(data, forKey: "inputMessage")

        guard let qrOutputImage = qrFilter.outputImage else {
            return Image(systemName: "xmark.circle")
        }

        let context = CIContext()
        guard let cgImage = context.createCGImage(qrOutputImage, from: qrOutputImage.extent) else {
            return Image(systemName: "xmark.circle")
        }

        let uiImage = UIImage(cgImage: cgImage)

        // Optionally, apply contrast adjustment here if needed
        let adjustedImage = applyContrastAdjustment(to: uiImage)

        return Image(uiImage: adjustedImage)
            .resizable()
            .interpolation(.none)
    }

    // Apply contrast adjustment to UIImage
    func applyContrastAdjustment(to image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else {
            return image
        }

        let colorControlsFilter = CIFilter.colorControls()
        colorControlsFilter.inputImage = ciImage
        colorControlsFilter.contrast = 3.0

        guard let outputImage = colorControlsFilter.outputImage else {
            return image
        }

        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }

        return UIImage(cgImage: cgImage)
    }
}
