import SwiftUI

struct CartView: View {
    let cartItems = [
        CartItem(name: "Product 1", price: 19.99, quantity: 2),
        CartItem(name: "Product 2", price: 29.99, quantity: 1),
        CartItem(name: "Product 3", price: 14.99, quantity: 3)
        // Add more dummy entries as needed
    ]

    var body: some View {
        VStack {
            Text("Shopping Cart")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            List(cartItems) { item in
                CartItemView(cartItem: item)
            }
            .listStyle(InsetListStyle())
            .padding()

            Spacer()
        }
    }
}

struct CartItemView: View {
    var cartItem: CartItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(cartItem.name)
                    .font(.headline)
                    .fontWeight(.bold)

                Text(String(format: "$%.2f", cartItem.price))
                    .foregroundColor(.gray)
            }

            Spacer()

            Text("Quantity: \(cartItem.quantity)")
                .foregroundColor(.blue)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.vertical, 4)
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let quantity: Int
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
