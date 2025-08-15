# Muslim Charity Donation App

A complete charity application ecosystem with Flutter mobile app and React web admin panel for connecting donors with verified needy individuals through mosque networks.

## 🎨 Color Scheme
- Primary Blue: `#0f67b1`
- Secondary Cyan: `#00caff`

## 📁 Project Structure

```
charity_app/
├── mobile_app/         # Flutter mobile application
├── admin_panel/        # React web admin panel
└── api_mock/          # Mock REST API server
```

## 🚀 Getting Started

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn
- Flutter SDK (3.0 or higher)
- Android Studio / Xcode (for mobile development)

### 1. Mock API Server

Navigate to the API directory and install dependencies:
```bash
cd api_mock
npm install
```

Start the API server:
```bash
npm start
```
The API will run on `http://localhost:3001`

### 2. Flutter Mobile App

Navigate to the mobile app directory:
```bash
cd mobile_app
```

Install Flutter dependencies:
```bash
flutter pub get
```

Run the app:
```bash
flutter run
```

Or build for specific platforms:
```bash
# Android
flutter build apk

# iOS
flutter build ios
```

### 3. React Admin Panel

Navigate to the admin panel directory:
```bash
cd admin_panel
npm install
```

Start the development server:
```bash
npm start
```
The admin panel will run on `http://localhost:3000`

Admin login credentials:
- Username: `admin`
- Password: `admin123`

## 📱 Mobile App Features

### User Roles

#### 1. **Imam/Mosque Representative**
- Verify and manage charity cases
- Add new cases for beneficiaries
- Submit cases for admin approval
- Track case progress and donations

#### 2. **Donor**
- Browse verified charity cases
- Filter by location, type, and status
- Make donations to specific cases
- Track donation history
- View case details and progress

#### 3. **Beneficiary**
- Submit personal cases for assistance
- Upload supporting documents
- Track case status and approval
- View donation progress

### Key Features
- Role-based registration and authentication
- Case browsing with advanced filters
- Secure mock payment processing
- Real-time case progress tracking
- Mosque verification system
- Multi-language support ready

## 💻 Admin Panel Features

### Dashboard
- Overview statistics
- Active cases monitoring
- Donation trends
- User activity tracking
- Real-time updates

### Case Management
- Review pending cases
- Approve/reject submissions
- Track case progress
- Manage case categories
- View supporting documents

### User Management
- View all registered users
- Verify user accounts
- Role management
- Activity monitoring

### Mosque Verification
- Review mosque registrations
- Verify authenticity
- Google Maps integration (mock)
- Manage mosque database

### Reports & Analytics
- Donation reports
- User activity analytics
- Case success rates
- Export functionality (CSV/PDF)
- Financial summaries

## 🔌 API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/verify-otp` - OTP verification
- `POST /api/auth/logout` - User logout

### Cases
- `GET /api/cases` - List all cases
- `POST /api/cases` - Create new case
- `PUT /api/cases/:id` - Update case
- `DELETE /api/cases/:id` - Delete case
- `POST /api/cases/:id/approve` - Approve case
- `POST /api/cases/:id/reject` - Reject case

### Users
- `GET /api/users` - List all users
- `PUT /api/users/:id` - Update user
- `POST /api/users/verify` - Verify user

### Donations
- `POST /api/donations` - Make donation
- `GET /api/donations/:userId` - Get user donations
- `GET /api/reports/donations` - Donation reports

## 🛠 Technology Stack

### Mobile App (Flutter)
- **State Management**: Provider
- **Navigation**: Named routes
- **Forms**: Built-in form validation
- **Storage**: Mock Firebase integration
- **UI**: Material Design

### Admin Panel (React)
- **Framework**: React with TypeScript
- **Routing**: React Router v6
- **State Management**: Context API
- **Charts**: Recharts
- **Styling**: CSS Modules
- **HTTP Client**: Axios

### API Server
- **Runtime**: Node.js
- **Framework**: Express.js
- **CORS**: Enabled for cross-origin requests
- **Body Parser**: JSON and URL-encoded

## 🧪 Testing

### Mobile App
```bash
cd mobile_app
flutter test
```

### Admin Panel
```bash
cd admin_panel
npm test
```

## 📝 Mock Data

The application comes with pre-populated mock data including:
- Sample users (Imams, Donors, Beneficiaries)
- Active charity cases
- Verified mosques
- Transaction history

## 🔒 Security Features

- Mock authentication system
- Role-based access control
- Input validation
- Secure mock payment processing
- Data encryption (simulated)
- CORS configuration

## 🚦 Development Status

✅ **Completed Features:**
- Flutter mobile app structure
- Role selection and registration flows
- Case browsing and donation features
- React admin panel
- Dashboard and case management
- Mock API layer
- Styling with brand colors

⏳ **Future Enhancements:**
- Real Firebase integration
- Actual payment gateway (GoPayFast)
- Push notifications
- Multi-language support
- Advanced analytics
- Real-time chat support
- Document verification AI

## 📄 License

This project is for demonstration purposes.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a pull request

## 📞 Support

For issues or questions, please create an issue in the repository.

---

Built with ❤️ for the Muslim community