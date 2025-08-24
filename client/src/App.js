import React, { useState, useEffect } from 'react';
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000';

function App() {
  const [users, setUsers] = useState([]);
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [status, setStatus] = useState({ message: '', type: '' });
  const [serverHealth, setServerHealth] = useState(null);

  useEffect(() => {
    checkServerHealth();
    fetchUsers();
  }, []);

  const checkServerHealth = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/api/health`);
      setServerHealth(response.data);
      setStatus({ message: 'Connected to server successfully!', type: 'success' });
    } catch (error) {
      console.error('Error checking server health:', error);
      setStatus({ message: 'Failed to connect to server', type: 'error' });
    }
  };

  const fetchUsers = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/api/users`);
      setUsers(response.data);
    } catch (error) {
      console.error('Error fetching users:', error);
      setStatus({ message: 'Failed to fetch users', type: 'error' });
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!name || !email) {
      setStatus({ message: 'Please fill in all fields', type: 'error' });
      return;
    }

    try {
      await axios.post(`${API_BASE_URL}/api/users`, { name, email });
      setName('');
      setEmail('');
      setStatus({ message: 'User added successfully!', type: 'success' });
      fetchUsers();
    } catch (error) {
      console.error('Error adding user:', error);
      setStatus({ message: 'Failed to add user', type: 'error' });
    }
  };

  return (
    <div className="container">
      <h1>Dummy App - Client-Server-Database Demo</h1>
      
      {serverHealth && (
        <div className="status success">
          <strong>Server Status:</strong> {serverHealth.message}
          <br />
          <strong>Last Check:</strong> {new Date(serverHealth.timestamp).toLocaleString()}
        </div>
      )}

      {status.message && (
        <div className={`status ${status.type}`}>
          {status.message}
        </div>
      )}

      <h2>Add New User</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="name">Name:</label>
          <input
            type="text"
            id="name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Enter name"
          />
        </div>
        <div className="form-group">
          <label htmlFor="email">Email:</label>
          <input
            type="email"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Enter email"
          />
        </div>
        <button type="submit">Add User</button>
        <button type="button" onClick={fetchUsers}>Refresh Users</button>
      </form>

      <div className="user-list">
        <h2>Users ({users.length})</h2>
        {users.length === 0 ? (
          <p>No users found. Add some users to see them here!</p>
        ) : (
          users.map((user) => (
            <div key={user.id} className="user-item">
              <strong>{user.name}</strong> - {user.email}
              <br />
              <small>ID: {user.id} | Created: {new Date(user.created_at).toLocaleString()}</small>
            </div>
          ))
        )}
      </div>
    </div>
  );
}

export default App;
