A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

This sample code handles HTTP GET requests to `/` and `/echo/<message>`

# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```

DB structure:

CREATE TABLE users (
  id SERIAL PRIMARY KEY,   -- auto-increment for primary key
  email VARCHAR(255) UNIQUE NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  avatar VARCHAR(255),
  password TEXT NOT NULL,  -- encrypted password
  role INTEGER NOT NULL,  -- Enum can be added for validation (e.g., 'admin', 'user')
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE projects (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  project_id INT NOT NULL REFERENCES projects(id),  -- Foreign key reference to projects
  created_by_id INT NOT NULL REFERENCES users(id),  -- Foreign key reference to users
  assignee_id INT REFERENCES users(id),  -- Nullable foreign key reference to users
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE task_linked_tasks (
  task_id INT NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,  -- Foreign key to task
  linked_task_id INT NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,  -- Foreign key to another task
  PRIMARY KEY (task_id, linked_task_id)
);
CREATE TABLE project_team_members (
  project_id INT NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  PRIMARY KEY (project_id, user_id)
);
