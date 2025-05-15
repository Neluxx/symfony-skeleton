# Database

If your project requires a database, ensure mysql is installed on your system. Then follow these steps:

- Set up the application and test database
``` mysql
CREATE SCHEMA `symfony_skeleton` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
CREATE SCHEMA `symfony_skeleton-test` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

- Run the migrations
``` bash
php bin/console doctrine:migrations:migrate
```