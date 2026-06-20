# User Documentation

This guide provides simple instructions on how to use, run, and check the Inception services.

---

## Services Provided by the Stack

The infrastructure provides three integrated services:
1.  **NGINX (Web Server / Gateway):** Serves as the secure entry point. It accepts secure HTTPS connections on port `443` and handles SSL certificate validation. It forwards website requests to WordPress and rejects insecure HTTP connections.
2.  **WordPress (Website):** The core content management system that runs your site. It processes content via PHP and generates dynamic web pages.
3.  **MariaDB (Database):** A relational database system storing all WordPress data (posts, pages, accounts, settings).

---

## Running the Project

### Starting the Infrastructure
To start the services for the first time or after a clean shutdown:
1.  Open your terminal.
2.  Navigate to the repository root directory.
3.  Run the following command:
    ```bash
    make
    ```
    *Note: If credentials haven't been generated yet, a setup script will automatically execute and prompt you for sudo permissions to configure the local domain routing. Follow the prompts.*

### Stopping the Infrastructure
To stop all services without deleting your data:
```bash
make down
```

---

## Accessing the Website and Admin Panel

The website is accessible locally using a secure domain address:

*   **Public WordPress Website:** `https://samcasti.42.fr`
*   **WordPress Administration Dashboard:** `https://samcasti.42.fr/wp-admin`

> [!NOTE]
> Since the certificates used are self-signed for local development, your browser will show a warning (e.g., "Your connection is not private"). This is normal. You can safely click **Advanced** -> **Proceed to samcasti.42.fr** to access the site.

---

## Managing Credentials

To protect the website, passwords and usernames are stored securely.

### Locating Your Credentials
Your credentials are automatically generated during setup and stored in the **`secrets/`** directory at the root of the project:
*   **WordPress user accounts and passwords:** `secrets/credentials.txt`
*   **Database standard user password:** `secrets/db_password.txt`
*   **Database administrator (root) password:** `secrets/db_root_password.txt`

### Changing or Resetting Credentials
To wipe out the existing credentials and generate fresh ones:
1.  Stop the project and wipe the configuration:
    ```bash
    make fclean
    ```
2.  Run the make command to generate new passwords and launch the services again:
    ```bash
    make
    ```

---

## Verifying That Services Are Running Correctly

To check the health and status of your active services, run the following verification steps:

### 1. Check Container Status
Run the following command to view running containers:
```bash
docker ps
```
You should see three active containers with a status of `Up`:
*   `nginx`
*   `wordpress`
*   `mariadb`

### 2. Verify Port Binding
Ensure NGINX is listening on port 443:
```bash
docker port nginx
```
Expected output:
`443/tcp -> 0.0.0.0:443`

### 3. Verify Container Health Logs
To inspect system-level logs and verify there are no startup failures, run:
```bash
docker compose -p inception -f srcs/docker-compose.yml logs
```
Look for successful launch messages (e.g., MariaDB ready for connections, php-fpm running, NGINX worker processes starting).
