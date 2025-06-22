# Proxmox Nginx Reverse Proxy Server

This project provides a lightweight Nginx configuration to act as a **reverse proxy** for internal Proxmox or Kubernetes services, enabling external HTTPS and HTTP access through domain-based routing.

---

## 🔧 Features

- **TCP stream-based SNI routing for HTTPS (port 443)**
- **HTTP reverse proxy** for port 80
- Easily forwards traffic to internal services using domain names
- Simplifies external access to Proxmox or internal Kubernetes apps

---

## 🧩 How It Works

### Stream (TCP Layer)
- Routes incoming TLS (HTTPS) traffic based on the `SNI` domain name using `$ssl_preread_server_name`
- Forwards HTTPS traffic for `app.domainname.online` to internal server `10.10.10.123:443`

### HTTP Layer
- Listens on port 80 for plain HTTP traffic to `app.domain.online`
- Proxies requests to `http://10.10.10.123.240`

---

## 📁 File: `nginx.conf`

Your configuration includes:

- `stream` block for SNI-based TLS proxy
- `http` block for standard HTTP reverse proxy
- Proper `proxy_set_header` directives to preserve client IPs and host headers

---

## 📦 Requirements

- Nginx (built with stream and ssl modules)
- DNS entry for `app.domain.online` pointing to your Nginx server
- Internal service accessible on `10.10.10.123:80/443`

---

## 🚀 Deployment

0. buy some cheap domainname and park it on your puiblic ip ot setting up dyn dns.
1. configure reverseproxy.tf & nginx.conf settings & ips regarding your needs
2. terraform init & apply
3. Install nginx and place `nginx.conf` in `/etc/nginx/nginx.conf`
4. Reload or restart Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl restart nginx
