---
root: false
targets: ["*"]
description: "Cloud Functions and Python code guidelines"
globs: ["**/*.py"]
---

# Cloud Functions Development Guidelines

## Python Code Style
- Follow PEP 8 conventions
- Use type hints for function parameters and returns
- Keep functions focused and single-purpose
- Handle errors gracefully with proper logging

## Cloud Function Best Practices
1. **Idempotency**: Functions should be idempotent
2. **Error Handling**: Always return appropriate HTTP status codes
3. **Timeouts**: Set reasonable timeouts (default: 60s)
4. **Memory**: Use minimal memory allocation (128MB for simple functions)
5. **Cold Starts**: Minimize dependencies to reduce cold start time

## Security
- Validate all inputs
- Use service accounts with minimal permissions
- Never log sensitive information
- Implement authentication for production use

## Testing
- Write unit tests for business logic
- Test error scenarios
- Verify HTTP response codes
- Test with curl or similar tools locally

## Deployment
- Use Cloud Storage for function source code
- Version your functions appropriately
- Monitor function execution and errors
- Set up alerts for failures