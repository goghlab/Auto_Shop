import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct MyqrcodeView: View {
    let uid: String
    @State private var isPaymentSetupNoticePresented = false
    @State private var isActivePaymentView = false
    @State private var isActiveCartView = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                VStack {
                    // Display QR code without the "wellcome" image
                    ZStack(alignment: .center) {
                        generateQRCode(from: uid)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300, alignment: .center)
                            .padding()
                    }
                    .padding(.trailing, 40)

                    Text("掃一掃進入AutoShop")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 20)
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
            .background(Color.white)
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
