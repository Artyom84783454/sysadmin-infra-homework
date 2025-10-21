# Decisions

## 1. Chosen Variables and Default Values

**Chosen variables:**
- `web_project_name` (default: "test_assignment") - setting project name
- `web_host_port` (default: 8080) - the basic port for web is port 80 but for local develope is better to use different one as 8080
- `web_app_env` (default: "dev") - using dev for development

## 2. Nginx and PHP-FPM Connection 

**Decision:** Nginx and PHP-FPM are connected with TCP via `fastcgi_pass {{ web_project_name }}_php:9000`

**Why TCP instead of Unix socket:**
- TCP is a bit slower then Unix socket but more secure for docker containers
- It`s one of best practices to use TCP for docker container comunication

## 3. Idempotency in Ansible

Files and configurations are copied to containers only if they have changed, and handlers are triggered only on actual changes. Subsequent runs do not alter the system unnecessarily

## 4. What exactly /healthz checks
**How it works:** Lightweight Nginx-level health check, No PHP processing is involved

```bash
curl http://localhost:8080/healthz
# getting JSON:
 {"status":"ok","service":"nginx","env":"dev"}
}
```
- status: ok → Nginx is up
- service: nginx → identifies the service
- env: dev → confirms the environment variable is set

**What it checks:**
- Status of Nginx
- Correct configuration
- Correct env

## 5. Improves

**If I had more time:**

1. **Better Linting** - Better linter configuration
2. **Better CI** - Better and cleaner Ci file with implementation of status of job
3. **Molecule Testing** - Better study the documentation of molecule and make configuration propertly
