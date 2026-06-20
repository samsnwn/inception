*This project has been created as part of the 42 curriculum by samcasti.*

# Inception

A system administration project introducing Docker, virtualization, and infrastructure design. The goal of this project is to build a secure, multi-container Web infrastructure using **Docker Compose** on Debian Bookworm.

---

## Description

The Inception project is a hands-on exploration of virtualization, microservice architecture, and system administration. It requires setting up a set of inter-dependent services running in separate Docker containers, communicating securely over a private Docker network. 

The architecture consists of:
*   **NGINX:** The entry point for all web traffic, configured as a TLS-only (HTTPS, Port 443) reverse proxy.
*   **WordPress + PHP-FPM:** The content management system, running on port 9000 and rendering PHP scripts.
*   **MariaDB:** The relational database storing all WordPress tables, communicating privately with WordPress on port 3306.

### Design Choices
1.  **Strict Microservice Separation:** Each container runs a single, dedicated daemon process (no multi-service orchestration tools like `systemd` or `supervisord`).
2.  **Debian (Bookworm) Base:** All custom images are built using Debian Bookworm (`debian:bookworm-slim`) for stability, packaging security, and lightweight container footprints.
3.  **Automatic, Safe Credential Provisioning:** Credentials and environment files are generated dynamically on first build using a dedicated `./setup.sh` script, avoiding the bad practice of storing keys in the source repository.
4.  **Least-Privilege Mounts:** Passwords are not passed to containers as environment variables. Instead, they are mounted strictly using Docker Secrets as transient files.

---

### Technical Comparisons

#### 1. Virtual Machines vs. Docker
| Feature | Virtual Machines (VMs) | Docker Containers |
| :--- | :--- | :--- |
| **Architecture** | Includes a full Guest OS + Hypervisor layer. | Shares the Host OS Kernel; contains only dependencies/app. |
| **Resource Usage** | High (demands pre-allocated CPU, RAM, and Disk space). | Minimal (shares host resources dynamically). |
| **Boot Time** | Minutes (needs to boot up a full operating system). | Seconds (spins up application processes immediately). |
| **Isolation** | Strong hardware-level isolation (very secure). | OS-level isolation (secure, but shares the same kernel). |

#### 2. Secrets vs. Environment Variables
*   **Environment Variables (`.env`):**
    *   *Exposure:* Inspectable by running `docker inspect <container>` or running `env` inside the container. They can also leak into error logs and application crash dumps.
    *   *Usage:* Best for non-sensitive configuration settings such as application URLs, database names, ports, and feature flags.
*   **Docker Secrets (`secrets/`):**
    *   *Exposure:* Stored in memory (tmpfs) and mounted inside the container as temporary files under `/run/secrets/`. They are never displayed in `docker inspect` or exposed to the parent environment.
    *   *Usage:* Required for highly sensitive data like database passwords, API tokens, and private SSL keys.

#### 3. Docker Network vs. Host Network
*   **Docker Network (Bridge Mode - Used here):**
    *   Creates a private, isolated virtual bridge network for the containers. 
    *   Containers communicate with each other using automatic DNS resolution via service names (e.g., WordPress connects to `mariadb:3306`).
    *   Ports are only exposed to the host machine if explicitly bound (e.g., NGINX on `443`). Other container ports remain private.
*   **Host Network:**
    *   Removes isolation between the containers and the host. The container shares the host machine's network interface directly.
    *   This improves raw throughput/performance but creates port conflicts if two containers use the same port and sacrifices secure container isolation.

#### 4. Docker Volumes vs. Bind Mounts
*   **Docker Volumes:**
    *   Fully managed by Docker daemon and stored in a designated area (e.g., `/var/lib/docker/volumes/`).
    *   More secure and decoupled from host filesystem permissions.
*   **Bind Mounts:**
    *   Directly mounts a specific, user-defined path on the host filesystem (e.g., `~/data/database`) into the container.
    *   Allows direct access and editing from the host, but depends on the host's directory structure, operating system, and file permissions.
    *   *Hybrid Note:* This project uses the **local volume driver with bind options**, allowing us to define custom paths on the host while keeping volume names inside Docker.

---

## Instructions

### Prerequisites
*   A UNIX-like host machine (macOS or Linux).
*   **Docker Desktop** or **Docker Engine** installed and running.
*   `make` installed on the host.

### Execution

1.  **Start the services:**
    Simply run the default Makefile target:
    ```bash
    make
    ```
    *Note: If `srcs/.env` or the `secrets/` directory do not exist, `make` will automatically trigger `./setup.sh` to generate random secure credentials and prompts you to enter your sudo password to bind `samcasti.42.fr` to your `/etc/hosts` file.*

2.  **Access the application:**
    Open your browser and navigate to:
    ```
    https://samcasti.42.fr
    ```
    *(You may see a self-signed certificate warning; this is expected because the SSL certificate is generated locally. Click 'Proceed' or 'Advanced' to bypass).*

3.  **Log in to WordPress:**
    *   **WordPress Admin:** `https://samcasti.42.fr/wp-admin`
    *   **Admin Credentials:** Refer to the terminal logs generated during the initial `make` setup.

---

### Makefile Commands

| Command | Action |
| :--- | :--- |
| `make` | Automates secrets/env creation, configures hosts, and boots containers in the foreground. |
| `make down` | Stops running containers. |
| `make clean` | Stops containers and removes all built images and anonymous volumes. |
| `make fclean` | Runs `clean`, deletes host data directories (`~/data`), deletes generated `secrets` and `.env`, and clears system caches. |
| `make re` | Forces a complete rebuild from scratch. |

---

## Resources

*   [Docker Documentation](https://docs.docker.com/)
*   [Debian packages](https://packages.debian.org/stable/)
*   [NGINX SSL/TLS configuration](https://nginx.org/en/docs/http/configuring_https_servers.html)
*   [WordPress Command Line Interface (WP-CLI)](https://wp-cli.org/)

### Use of AI
AI assistance was utilized during the development of this project for:
1.  **Documentation:** Writing technical comparative sections explaining Docker infrastructure concepts and architectural differences.
2. **Research:** Researching main concepts utilized in this project.
