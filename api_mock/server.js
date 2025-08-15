const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3001;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Mock data storage
let users = [
  {
    id: 'user_001',
    cnic: '42101-1234567-8',
    phoneNumber: '+923001234567',
    location: 'Karachi',
    role: 'imam',
    isVerified: true,
    additionalInfo: {
      mosqueName: 'Masjid Al-Noor',
      mosqueAddress: 'Block 5, Gulshan-e-Iqbal'
    },
    createdAt: new Date().toISOString()
  }
];

let cases = [
  {
    id: 'case_001',
    beneficiaryName: 'Sara Ahmed',
    beneficiaryId: 'ben_001',
    title: 'Urgent Medical Treatment for Heart Surgery',
    description: 'Sara Ahmed, a 45-year-old mother of three, urgently needs heart surgery.',
    type: 'medical',
    targetAmount: 500000,
    raisedAmount: 125000,
    location: 'Karachi, Gulshan-e-Iqbal',
    mosqueId: 'mosque_001',
    mosqueName: 'Masjid Al-Noor',
    isImamVerified: true,
    isAdminApproved: false,
    status: 'pending',
    createdAt: new Date().toISOString()
  }
];

let donations = [];
let mosques = [];

// Authentication endpoints
app.post('/api/auth/login', (req, res) => {
  const { cnic, phoneNumber } = req.body;
  
  const user = users.find(u => u.cnic === cnic && u.phoneNumber === phoneNumber);
  
  if (user) {
    res.json({
      success: true,
      user,
      token: 'mock_token_' + Date.now()
    });
  } else {
    res.status(401).json({
      success: false,
      message: 'Invalid credentials'
    });
  }
});

app.post('/api/auth/register', (req, res) => {
  const newUser = {
    id: 'user_' + Date.now(),
    ...req.body,
    isVerified: false,
    createdAt: new Date().toISOString()
  };
  
  users.push(newUser);
  
  res.json({
    success: true,
    user: newUser
  });
});

app.post('/api/auth/verify-otp', (req, res) => {
  res.json({
    success: true,
    message: 'OTP verified successfully'
  });
});

app.post('/api/auth/logout', (req, res) => {
  res.json({
    success: true,
    message: 'Logged out successfully'
  });
});

// Case Management endpoints
app.get('/api/cases', (req, res) => {
  const { status, type, location } = req.query;
  
  let filteredCases = [...cases];
  
  if (status) {
    filteredCases = filteredCases.filter(c => c.status === status);
  }
  
  if (type) {
    filteredCases = filteredCases.filter(c => c.type === type);
  }
  
  if (location) {
    filteredCases = filteredCases.filter(c => 
      c.location.toLowerCase().includes(location.toLowerCase())
    );
  }
  
  res.json({
    success: true,
    cases: filteredCases
  });
});

app.post('/api/cases', (req, res) => {
  const newCase = {
    id: 'case_' + Date.now(),
    ...req.body,
    raisedAmount: 0,
    isAdminApproved: false,
    status: 'pending',
    createdAt: new Date().toISOString()
  };
  
  cases.push(newCase);
  
  res.json({
    success: true,
    case: newCase
  });
});

app.put('/api/cases/:id', (req, res) => {
  const { id } = req.params;
  const caseIndex = cases.findIndex(c => c.id === id);
  
  if (caseIndex !== -1) {
    cases[caseIndex] = {
      ...cases[caseIndex],
      ...req.body,
      updatedAt: new Date().toISOString()
    };
    
    res.json({
      success: true,
      case: cases[caseIndex]
    });
  } else {
    res.status(404).json({
      success: false,
      message: 'Case not found'
    });
  }
});

app.delete('/api/cases/:id', (req, res) => {
  const { id } = req.params;
  cases = cases.filter(c => c.id !== id);
  
  res.json({
    success: true,
    message: 'Case deleted successfully'
  });
});

app.post('/api/cases/:id/approve', (req, res) => {
  const { id } = req.params;
  const caseIndex = cases.findIndex(c => c.id === id);
  
  if (caseIndex !== -1) {
    cases[caseIndex].isAdminApproved = true;
    cases[caseIndex].status = 'active';
    
    res.json({
      success: true,
      case: cases[caseIndex]
    });
  } else {
    res.status(404).json({
      success: false,
      message: 'Case not found'
    });
  }
});

app.post('/api/cases/:id/reject', (req, res) => {
  const { id } = req.params;
  const caseIndex = cases.findIndex(c => c.id === id);
  
  if (caseIndex !== -1) {
    cases[caseIndex].isAdminApproved = false;
    cases[caseIndex].status = 'rejected';
    
    res.json({
      success: true,
      case: cases[caseIndex]
    });
  } else {
    res.status(404).json({
      success: false,
      message: 'Case not found'
    });
  }
});

// User Management endpoints
app.get('/api/users', (req, res) => {
  const { role } = req.query;
  
  let filteredUsers = [...users];
  
  if (role) {
    filteredUsers = filteredUsers.filter(u => u.role === role);
  }
  
  res.json({
    success: true,
    users: filteredUsers
  });
});

app.put('/api/users/:id', (req, res) => {
  const { id } = req.params;
  const userIndex = users.findIndex(u => u.id === id);
  
  if (userIndex !== -1) {
    users[userIndex] = {
      ...users[userIndex],
      ...req.body
    };
    
    res.json({
      success: true,
      user: users[userIndex]
    });
  } else {
    res.status(404).json({
      success: false,
      message: 'User not found'
    });
  }
});

app.post('/api/users/verify', (req, res) => {
  const { userId } = req.body;
  const userIndex = users.findIndex(u => u.id === userId);
  
  if (userIndex !== -1) {
    users[userIndex].isVerified = true;
    
    res.json({
      success: true,
      user: users[userIndex]
    });
  } else {
    res.status(404).json({
      success: false,
      message: 'User not found'
    });
  }
});

// Donation endpoints
app.post('/api/donations', (req, res) => {
  const newDonation = {
    id: 'donation_' + Date.now(),
    ...req.body,
    timestamp: new Date().toISOString()
  };
  
  donations.push(newDonation);
  
  // Update case raised amount
  const caseIndex = cases.findIndex(c => c.id === req.body.caseId);
  if (caseIndex !== -1) {
    cases[caseIndex].raisedAmount += req.body.amount;
  }
  
  res.json({
    success: true,
    donation: newDonation
  });
});

app.get('/api/donations/:userId', (req, res) => {
  const { userId } = req.params;
  const userDonations = donations.filter(d => d.donorId === userId);
  
  res.json({
    success: true,
    donations: userDonations
  });
});

app.get('/api/reports/donations', (req, res) => {
  const totalDonations = donations.reduce((sum, d) => sum + d.amount, 0);
  const totalCases = cases.length;
  const activeCases = cases.filter(c => c.status === 'active').length;
  
  res.json({
    success: true,
    report: {
      totalDonations,
      totalCases,
      activeCases,
      donationCount: donations.length,
      averageDonation: donations.length > 0 ? totalDonations / donations.length : 0
    }
  });
});

// Mosque endpoints
app.get('/api/mosques', (req, res) => {
  res.json({
    success: true,
    mosques
  });
});

app.post('/api/mosques/verify', (req, res) => {
  const { mosqueId } = req.body;
  const mosqueIndex = mosques.findIndex(m => m.id === mosqueId);
  
  if (mosqueIndex !== -1) {
    mosques[mosqueIndex].isVerified = true;
    
    res.json({
      success: true,
      mosque: mosques[mosqueIndex]
    });
  } else {
    res.status(404).json({
      success: false,
      message: 'Mosque not found'
    });
  }
});

// Admin endpoints
app.post('/api/admin/login', (req, res) => {
  const { username, password } = req.body;
  
  if (username === 'admin' && password === 'admin123') {
    res.json({
      success: true,
      token: 'admin_token_' + Date.now(),
      user: {
        id: 'admin_1',
        username: 'admin',
        role: 'super_admin'
      }
    });
  } else {
    res.status(401).json({
      success: false,
      message: 'Invalid admin credentials'
    });
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString()
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Mock API server running on http://localhost:${PORT}`);
  console.log('Available endpoints:');
  console.log('- POST /api/auth/login');
  console.log('- POST /api/auth/register');
  console.log('- GET /api/cases');
  console.log('- POST /api/cases');
  console.log('- POST /api/donations');
  console.log('- GET /api/users');
  console.log('- POST /api/admin/login');
});