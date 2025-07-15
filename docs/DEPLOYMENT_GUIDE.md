# 🚀 Deployment Guide

**Project**: Bullhorn Email Checker Actor  
**Version**: 2.1 (Production Ready)  
**Status**: ✅ **Enterprise Deployment Ready**

---

## 🎯 **Overview**

This guide provides **comprehensive deployment instructions** for the Bullhorn Email Checker Actor across multiple environments, from local development to enterprise production deployment with Zapier integration.

## 📋 **Prerequisites**

### **Required Tools**

- **Apify CLI**: Latest version (`npm install -g apify-cli`)
- **Node.js**: Version 18+
- **Git**: For version control
- **Docker**: For containerized deployment (optional)

### **Required Accounts**

- **Apify Account**: For actor deployment
- **Bullhorn CRM Access**: Valid credentials with candidate database access
- **GitHub Account**: For repository management
- **Zapier Account**: For workflow integration (optional)

### **Required Credentials**

- **Bullhorn Username**: CRM login username
- **Bullhorn Password**: CRM login password
- **Bullhorn CRM URL**: Login endpoint (typically `https://universal.bullhornstaffing.com/universal-login/login`)

---

## 🏗️ **Deployment Environments**

### **1. Local Development Environment**

#### **Setup Process**

```bash
# Clone repository
git clone https://github.com/triggerNode/Bullhorn_Actor.git
cd Bullhorn_Actor

# Install dependencies
npm install

# Configure environment variables
cp .env.example .env
```

#### **Environment Configuration**

Create `.env` file:

```bash
CRM_USERNAME=your.bullhorn.username
CRM_PASSWORD=your.bullhorn.password
CRM_URL=https://universal.bullhornstaffing.com/universal-login/login
```

#### **Local Testing**

```bash
# Test with sample email
echo '{"email": "test@example.com"}' > test-input.json

# Run actor locally
apify run --input=test-input.json

# Expected output
{
  "email": "test@example.com",
  "exists": false,
  "candidateId": null,
  "matchType": null,
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

---

### **2. Apify Platform Deployment**

#### **Deployment Process**

```bash
# Initialize Apify project (if not already done)
apify init

# Configure actor settings
# Edit .actor/actor.json with proper version

# Deploy to Apify
apify push -v 2.1 -b latest
```

#### **Critical Deployment Settings**

**Actor Configuration (`.actor/actor.json`)**:

```json
{
  "actorSpecification": 1,
  "name": "bullhorn-email-checker",
  "title": "Bullhorn Email Checker",
  "version": "2.1",
  "defaultRunOptions": {
    "build": "latest",
    "timeoutSecs": 300,
    "memoryMbytes": 4096
  }
}
```

**Input Schema (`.actor/input_schema.json`)**:

```json
{
  "type": "object",
  "schemaVersion": 1,
  "properties": {
    "email": {
      "title": "Email Address",
      "type": "string",
      "description": "The email address to search for",
      "pattern": "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$",
      "editor": "textfield"
    },
    "username": {
      "title": "CRM Username",
      "type": "string",
      "description": "Bullhorn CRM username (required for Apify deployment)",
      "editor": "textfield"
    },
    "password": {
      "title": "CRM Password",
      "type": "string",
      "description": "Bullhorn CRM password (required for Apify deployment)",
      "editor": "textfield"
    },
    "crmUrl": {
      "title": "CRM URL",
      "type": "string",
      "description": "Bullhorn CRM login URL",
      "default": "https://universal.bullhornstaffing.com/universal-login/login",
      "editor": "textfield"
    }
  },
  "required": ["email", "username", "password", "crmUrl"]
}
```

#### **Environment Detection**

The actor automatically detects deployment environment:

```javascript
// Automatic environment detection
const isApifyDeployment = !!process.env.APIFY_ACTOR_ID;

if (isApifyDeployment) {
  // APIFY MODE: All credentials required via input
  // Validates all required fields present
} else {
  // LOCAL MODE: Support both input and .env fallback
  // Falls back to environment variables
}
```

---

### **3. Multi-User Production Deployment**

#### **Enterprise Configuration**

For **multi-team deployment** where different users have their own Bullhorn credentials:

**Deployment Strategy**:

1. **Single Actor Instance**: One deployed actor handles multiple users
2. **Input-Based Credentials**: Each user provides their own credentials
3. **Security Isolation**: No shared credentials or cross-user data access

**Usage Example**:

```json
{
  "email": "candidate@example.com",
  "username": "team1.username",
  "password": "team1.password",
  "crmUrl": "https://universal.bullhornstaffing.com/universal-login/login"
}
```

#### **Security Best Practices**

1. **Credential Management**:

   - Never hardcode credentials in actor
   - Use input parameters for multi-user scenarios
   - Implement credential validation and error handling

2. **Access Control**:

   - Limit actor access to authorized users only
   - Use Apify's access control features
   - Monitor usage and audit logs

3. **Data Protection**:
   - No persistent storage of credentials
   - Secure logging without credential exposure
   - Clean memory after execution

---

## 🔗 **Zapier Integration Deployment**

### **Integration Setup Process**

#### **Step 1: Connect Apify to Zapier**

1. **In Zapier**: Add new step → Search for "Apify"
2. **Select Action**: "Run Actor"
3. **Connect Account**: Authenticate with Apify API key
4. **Select Actor**: `triggernode/bullhorn-email-checker`

#### **Step 2: Configure Actor Settings**

**Required Settings**:

```
Actor: triggernode/bullhorn-email-checker
Build: latest
Run Synchronously: Yes
Memory: 4096 MB
Timeout: 300 seconds
```

#### **Step 3: Configure Input Mapping**

**Input Configuration**:

```json
{
  "email": "{{email_from_previous_step}}",
  "username": "{{bullhorn_username}}",
  "password": "{{bullhorn_password}}",
  "crmUrl": "{{bullhorn_url}}"
}
```

#### **Step 4: Handle Output**

**Expected Output Structure**:

```json
{
  "email": "candidate@example.com",
  "exists": true,
  "candidateId": "12345",
  "matchType": "exact",
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

**Usage in Subsequent Steps**:

- Access result via: `{{output.exists}}`
- Get candidate ID via: `{{output.candidateId}}`
- Check email via: `{{output.email}}`

---

## 🔧 **Deployment Troubleshooting**

### **Common Issues & Solutions**

#### **Issue 1: Schema Propagation Problems**

**Symptoms**: Missing fields in Zapier interface
**Root Cause**: Build tagging or schema caching issues

**Solution**:

```bash
# Ensure proper version tagging
apify push -v 2.1 -b latest

# Clear Zapier cache
# 1. Disconnect Zapier integration
# 2. Wait 5 minutes
# 3. Reconnect with fresh authentication
```

#### **Issue 2: Credential Validation Errors**

**Symptoms**: "Missing required credentials" error
**Root Cause**: Environment detection or input validation

**Solution**:

1. **For Apify Deployment**: Ensure all fields (email, username, password, crmUrl) are provided
2. **For Local Development**: Check `.env` file configuration
3. **For Zapier**: Verify all credential fields are mapped

#### **Issue 3: Performance Issues**

**Symptoms**: Timeouts or slow execution
**Root Cause**: Network latency or Bullhorn server load

**Solution**:

1. **Increase Timeout**: Set to 300+ seconds in Apify/Zapier
2. **Memory Allocation**: Ensure 4GB memory allocation
3. **Retry Logic**: Implement automatic retry in workflow

#### **Issue 4: Authentication Failures**

**Symptoms**: Login errors or access denied
**Root Cause**: Invalid credentials or account permissions

**Solution**:

1. **Verify Credentials**: Test credentials directly in Bullhorn
2. **Check Permissions**: Ensure account has candidate database access
3. **Update Credentials**: Rotate credentials if expired

---

## 📊 **Monitoring & Maintenance**

### **Performance Monitoring**

**Key Metrics to Track**:

- **Execution Time**: Should average ~22 seconds
- **Success Rate**: Should maintain 100% for valid emails
- **Memory Usage**: Should stay within 4GB allocation
- **Error Rate**: Should be minimal for valid credentials

**Monitoring Tools**:

- **Apify Console**: Actor execution logs and statistics
- **Zapier History**: Workflow execution tracking
- **Custom Alerts**: Set up alerts for failures or performance degradation

### **Maintenance Schedule**

**Weekly**:

- Review execution logs for any errors
- Monitor performance metrics
- Check credential validity

**Monthly**:

- Update dependencies if security patches available
- Review and optimize performance if needed
- Audit access logs and usage patterns

**Quarterly**:

- Comprehensive security review
- Performance optimization assessment
- Documentation updates

---

## 🚀 **Advanced Deployment Scenarios**

### **High-Availability Deployment**

For **enterprise-grade reliability**:

1. **Multiple Actor Instances**: Deploy across different regions
2. **Load Balancing**: Distribute requests across instances
3. **Failover Logic**: Automatic fallback to backup instances
4. **Health Checks**: Regular monitoring and alerting

### **Batch Processing**

For **high-volume email checking**:

1. **Batch Input Processing**: Modified actor for multiple emails
2. **Queue Management**: Handle large volumes efficiently
3. **Rate Limiting**: Respect Bullhorn API limits
4. **Progress Tracking**: Monitor batch completion status

### **Custom Integration**

For **specialized deployment needs**:

1. **API Wrapper**: Custom API around the actor
2. **Webhook Integration**: Real-time processing triggers
3. **Database Integration**: Direct database connectivity
4. **Custom Authentication**: SSO or specialized auth methods

---

## ✅ **Deployment Validation**

### **Pre-Deployment Checklist**

- [ ] **Code Review**: All changes reviewed and approved
- [ ] **Testing**: Local testing completed successfully
- [ ] **Credentials**: Valid Bullhorn credentials configured
- [ ] **Version**: Proper version number and build tag
- [ ] **Documentation**: Deployment notes updated

### **Post-Deployment Validation**

- [ ] **Functionality Test**: Run test email verification
- [ ] **Performance Check**: Verify ~22 second execution time
- [ ] **Integration Test**: Test Zapier integration if applicable
- [ ] **Monitoring Setup**: Alerts and monitoring configured
- [ ] **Access Control**: Proper permissions and security verified

### **Rollback Plan**

If issues arise:

1. **Immediate**: Revert to previous version using Apify console
2. **Emergency**: Use backup version (main.js.backup)
3. **Communication**: Notify affected users and stakeholders
4. **Analysis**: Document issues for future prevention

---

## 🎯 **Success Criteria**

### **Deployment Success Indicators**

✅ **Functional Success**:

- Actor executes without errors
- Email detection works correctly
- Proper JSON output format
- Integration with target systems working

✅ **Performance Success**:

- Execution time ≤ 25 seconds average
- Memory usage within 4GB allocation
- Success rate ≥ 99% for valid inputs
- No timeout issues

✅ **Integration Success**:

- Zapier workflows functioning properly
- Multi-user credentials working
- Proper error handling and logging
- Documentation accessible and accurate

---

_Deployment guide completed: January 2025_  
_Status: Production-ready with comprehensive deployment support_  
_Coverage: Local development through enterprise production deployment_
