# Bullhorn Email Checker

This Apify actor checks if an email address exists in the Bullhorn CRM candidate database. **Version 2.0** introduces multi-user support with flexible credential management.

## 🚀 Features

- ✅ **Reliable Email Detection**: Advanced matching algorithms with multiple fallback strategies
- 🔐 **Flexible Credentials**: Supports both environment variables and input-based credentials
- 🌐 **Multi-User Ready**: Perfect for Zapier integrations and shared environments
- ⚡ **High Performance**: Optimized for speed and reliability
- 📊 **Detailed Results**: Returns email status, candidate ID, and timestamp

## 📝 Usage

### Input Parameters

#### Required

- `email` - The email address to search for

#### Optional (Multi-User Mode)

- `username` - Bullhorn CRM username (secure field)
- `password` - Bullhorn CRM password (secure field)
- `crmUrl` - Bullhorn CRM login URL

### Credential Methods

#### Method 1: Environment Variables (Legacy)

Set these environment variables (e.g., in `.env` file):

```
CRM_USERNAME=your.username
CRM_PASSWORD=your.password
CRM_URL=https://universal.bullhornstaffing.com/universal-login/login
```

#### Method 2: Input Parameters (Multi-User)

Provide credentials directly in the actor input:

```json
{
  "email": "john.doe@example.com",
  "username": "your.username",
  "password": "your.password",
  "crmUrl": "https://universal.bullhornstaffing.com/universal-login/login"
}
```

## 📤 Output

The actor returns a JSON object with:

- `email` - The searched email address
- `exists` - Boolean indicating if the email was found
- `candidateId` - The candidate ID if found (null if not found)
- `matchType` - How the match was found (exact, partial, text_contains, username)
- `timestamp` - When the search was performed

## 📋 Examples

### Example Input (Environment Method)

```json
{
  "email": "john.doe@example.com"
}
```

### Example Input (Multi-User Method)

```json
{
  "email": "john.doe@example.com",
  "username": "api.user",
  "password": "secure.password",
  "crmUrl": "https://universal.bullhornstaffing.com/universal-login/login"
}
```

### Example Output

```json
{
  "email": "john.doe@example.com",
  "exists": true,
  "candidateId": "12345",
  "matchType": "exact",
  "timestamp": "2025-07-15T20:30:00.000Z"
}
```

## 🔐 Security

- Credentials are never logged in plain text
- Input-based credentials are marked as secure fields in Apify
- Supports encrypted credential storage in Zapier integrations
- Automatic credential source detection and logging

## 🔧 Configuration

- **Memory**: 4096 MB recommended
- **Timeout**: 300 seconds (5 minutes)
- **Build**: Use "latest" for most recent optimizations

## 🌐 Zapier Integration

Perfect for Zapier workflows:

1. Set up Apify integration in Zapier
2. Configure actor: `bullhorn-email-checker`
3. Provide email + credentials as input fields
4. Use output to trigger conditional workflows
