# SwiftWallet

A comprehensive mobile money transfer application with Android support, backend services, and admin panel.

## Project Structure

```
SwiftWallet/
├── mobile/          # Flutter mobile application
├── backend/         # Node.js/Express.js backend
├── admin-panel/     # Vue.js admin panel
└── docs/            # Project documentation
```

## Technology Stack

### Mobile App (Flutter)
- Flutter (Dart)
- State Management: Provider
- HTTP Client: http package
- QR Code: qr_flutter, qr_code_scanner

### Backend
- Node.js
- Express.js
- MySQL
- Sequelize ORM
- JWT Authentication

### Admin Panel
- Vue.js
- Vue Router
- Vuex
- Element Plus UI

## Features

### User Features
- User registration and login
- Phone number verification
- Send money via phone number
- Send/receive money via QR code
- Transaction history
- Profile management

### Merchant Features
- Basic merchant accounts
- QR code payment reception

### Admin Features
- User management
- Transaction monitoring
- Merchant management

## Getting Started

### Prerequisites
- Flutter SDK
- Node.js
- MySQL
- Git

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd SwiftWallet
```

2. Set up the mobile app:
```bash
cd mobile
flutter pub get
```

3. Set up the backend:
```bash
cd backend
npm install
```

4. Set up the admin panel:
```bash
cd admin-panel
npm install
```

## Development

- Mobile App: `cd mobile && flutter run`
- Backend: `cd backend && npm run dev`
- Admin Panel: `cd admin-panel && npm run serve`

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

[License information to be added]

## Contact

[Contact information to be added] 