# API Documentation

This directory contains the API documentation for the AI-Driven Applications Suite.

## Overview

The API is organized into three main services:

1. Crypto Price Prediction API
2. Document OCR API
3. Marketing Analytics API

Each service follows RESTful principles and uses JSON for request/response payloads.

## Authentication

All APIs require authentication using JWT tokens. Tokens can be obtained from the authentication service.

```bash
# Example token request
curl -X POST https://api.example.com/auth/token \
  -H "Content-Type: application/json" \
  -d '{"username": "user", "password": "pass"}'
```

## Common Headers

All requests should include:

```http
Authorization: Bearer <token>
Content-Type: application/json
Accept: application/json
```

## Rate Limiting

APIs are rate-limited based on:
- 100 requests per minute for free tier
- 1000 requests per minute for pro tier
- Custom limits for enterprise tier

## API Services

### 1. Crypto Price Prediction API

- [Detailed Documentation](crypto/README.md)
- Base URL: `/api/v1/crypto`
- Endpoints:
  - GET `/predictions`
  - POST `/analyze`
  - GET `/historical`

### 2. Document OCR API

- [Detailed Documentation](ocr/README.md)
- Base URL: `/api/v1/ocr`
- Endpoints:
  - POST `/scan`
  - GET `/results`
  - POST `/batch`

### 3. Marketing Analytics API

- [Detailed Documentation](analytics/README.md)
- Base URL: `/api/v1/analytics`
- Endpoints:
  - GET `/metrics`
  - POST `/reports`
  - GET `/insights`

## Response Formats

### Success Response

```json
{
  "status": "success",
  "data": {
    "id": "123",
    "result": "value"
  },
  "metadata": {
    "timestamp": "2025-03-24T00:29:53Z",
    "version": "1.0"
  }
}
```

### Error Response

```json
{
  "status": "error",
  "error": {
    "code": "ERR_INVALID_INPUT",
    "message": "Invalid input parameters",
    "details": {
      "field": "amount",
      "issue": "Must be positive number"
    }
  },
  "metadata": {
    "timestamp": "2025-03-24T00:29:53Z",
    "requestId": "req_123"
  }
}
```

## Error Codes

| Code | Description |
|------|-------------|
| ERR_INVALID_INPUT | Invalid input parameters |
| ERR_UNAUTHORIZED | Authentication required |
| ERR_FORBIDDEN | Permission denied |
| ERR_NOT_FOUND | Resource not found |
| ERR_RATE_LIMIT | Rate limit exceeded |
| ERR_SERVER | Internal server error |

## Versioning

APIs are versioned using URL path:
- `/api/v1/` - Current stable version
- `/api/v2/` - Beta features
- `/api/latest/` - Latest development version

## Documentation Structure

```
api/
├── README.md           # This file
├── crypto/            # Crypto API docs
│   ├── README.md
│   ├── endpoints.md
│   └── examples.md
├── ocr/               # OCR API docs
│   ├── README.md
│   ├── endpoints.md
│   └── examples.md
└── analytics/         # Analytics API docs
    ├── README.md
    ├── endpoints.md
    └── examples.md
```

## Development Guidelines

1. **API Design**
   - Follow RESTful principles
   - Use consistent naming conventions
   - Provide comprehensive documentation
   - Include examples and use cases

2. **Testing**
   - Write API tests
   - Validate request/response schemas
   - Test error scenarios
   - Monitor performance

3. **Security**
   - Implement authentication
   - Validate inputs
   - Rate limit requests
   - Log access attempts

4. **Maintenance**
   - Monitor usage metrics
   - Track error rates
   - Update documentation
   - Version control changes

## Tools and Resources

1. **API Testing**
   - Postman collections
   - Integration tests
   - Load testing scripts
   - Monitoring dashboards

2. **Documentation**
   - OpenAPI/Swagger specs
   - API blueprints
   - Example code
   - Client libraries

3. **Development**
   - API development guide
   - Style guide
   - Best practices
   - Code templates

## Support

For API support:
1. Check the documentation
2. Review common issues
3. Contact API team
4. Submit support ticket

## Contributing

To contribute to the API:
1. Review API guidelines
2. Fork the repository
3. Make changes
4. Submit pull request

## License

API documentation and examples are licensed under the same terms as the main project.
