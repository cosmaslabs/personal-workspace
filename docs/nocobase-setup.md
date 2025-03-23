# Nocobase Setup Guide

## Prerequisites

- Node.js 16.x or later
- Git
- PostgreSQL (recommended) or MySQL
- yarn

## Installation Steps

**1. Clone Nocobase repository:**

```bash
git clone https://github.com/nocobase/nocobase.git E:/Personal/nocobase
cd E:/Personal/nocobase
```

**2. Environment Setup**:

```bash
# Install dependencies
yarn install

# Create .env file
cp .env.example .env
```

**3. Configure your .env file with these recommended enterprise settings:**

```ini
# Database Configuration
DB_DIALECT=postgres  # or mysql
DB_HOST=localhost
DB_PORT=5432        # 3306 for MySQL
DB_DATABASE=nocobase
DB_USER=your_user
DB_PASSWORD=your_password

# Application Configuration
APP_PORT=13000      # Choose a port that doesn't conflict with other services
APP_HOST=0.0.0.0    # Listen on all interfaces
NODE_ENV=production # For production environment

# Storage Configuration
STORAGE_TYPE=local
LOCAL_STORAGE_DIR=storage

# Cache Configuration
CACHE_ENABLED=true
CACHE_TYPE=memory   # or redis for production

# Security Configuration
JWT_SECRET=your_secure_jwt_secret
JWT_EXPIRES_IN=7d
```

**4. Database Setup:**

```bash
# Initialize the database
yarn nocobase install --lang=en-US
```

**5. Start the Application:**
yarn dev

## Production mode

```bash
# Production mode
yarn build
yarn start
```

## Enterprise Configuration Best Practices

### Security

- Use strong passwords for database access
- Configure SSL/TLS for database connections
- Implement rate limiting
- Set up proper firewall rules
- Use environment variables for sensitive data
- Regular security audits

### Performance

- Configure database connection pooling
- Implement caching strategies
- Monitor resource usage
- Set up logging and monitoring

### Backup & Recovery

- Regular database backups
- Transaction logs
- Disaster recovery plan
- Data retention policies

### Maintenance

- Regular updates and patches
- System health checks
- Performance monitoring
- Log rotation

## Accessing the Application

- Admin interface: <http://localhost:13000/admin/>
- Default admin credentials:
  - Email: <admin@nocobase.com>
  - Password: admin123

## Common Issues and Solutions

1. Database Connection Issues:
   - Verify database credentials
   - Check database service status
   - Confirm firewall settings

2. Permission Issues:
   - Ensure proper file permissions
   - Check database user privileges
   - Verify service account permissions

3. Performance Issues:
   - Monitor database query performance
   - Check system resources
   - Optimize database indexes
   - Implement caching

## Monitoring & Maintenance

1. Set up monitoring for:
   - System resources (CPU, Memory, Disk)
   - Application logs
   - Database performance
   - API response times

2. Regular maintenance tasks:
   - Database optimization
   - Log rotation
   - Cache clearing
   - Security updates

## Support Resources

- Official Documentation: <https://docs.nocobase.com/>
- GitHub Repository: <https://github.com/nocobase/nocobase>
- Community Forum: <https://forum.nocobase.com/>
